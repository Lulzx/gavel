"""The baseline policies calibration measures against.

A policy turns an observation into an ``Action``. Two live here: one that asks
a model, and one that replays a fixed script so the plumbing can be tested
without spending anything.

The API call is ``urllib`` rather than the SDK on purpose. The harness has no
runtime dependencies -- a reward function that cannot be reinstalled is a
reward function that cannot be trusted -- and one POST does not justify being
the first.
"""

from __future__ import annotations

import json
import os
import urllib.error
import urllib.request
from dataclasses import dataclass, field
from typing import Any, Protocol

from .env import Action
from .tasks import PROOF_FILE, SOLUTION_FILE

API_URL = "https://api.anthropic.com/v1/messages"
API_VERSION = "2023-06-01"
DEFAULT_MODEL = "claude-opus-5"
DEFAULT_MAX_TOKENS = 8192

SYSTEM = """\
You are writing a proof in Bend 2.0.5, a dependently typed language with no \
tactics. A task gives you:

- `LAWS.bend`: the definitions you may not edit, each declaring a law over a \
  module `S` (your solution) that you must prove.
- `solution.bend`: a stub with the definitions you must fill in. It imports \
  what it needs; keep its imports.
- The import header your proof file must begin with.

Reply with one JSON object and nothing else:

{"solution": "<full contents of solution.bend>", "proof": "<full contents of PROOF.bend>"}

The proof file declares, for each law, a def named `L.<law>` whose body is a \
proof term. Useful facts about the checker:

- `{a == b : T}` is an equality type; `{==}` closes a goal whose sides are \
  already the same after reduction.
- `match x:` with `case 0n:` and `case 1n+p:` for `Nat`; `case Nil{}:` and \
  `case h <> t:` for `List<T>`.
- `%e : P` rewrites with `e : {a == b : T}`. Write `P` as the goal with `_` \
  where `b` goes, after reducing both sides as far as they go.
- `?TODO` is a hole and proves nothing. `@unsafe` is rejected outright.
- Put one binder per line: `for x: Nat` then `for y: Nat`, never both on one.
- Goal types must match exactly; partial application is not accepted."""


class Policy(Protocol):
    name: str

    def __call__(self, observation: dict[str, Any]) -> Action: ...


class PolicyError(RuntimeError):
    pass


# --- parsing the model's reply --------------------------------------------------

def extract_json(text: str) -> dict[str, Any]:
    """The first JSON object in ``text``, tolerating prose and code fences.

    Models wrap JSON in ```json fences often enough that requiring a bare
    object would throw away answers that are otherwise correct.
    """
    start = text.find("{")
    while start != -1:
        depth, in_string, escaped = 0, False, False
        for i in range(start, len(text)):
            char = text[i]
            if in_string:
                if escaped:
                    escaped = False
                elif char == "\\":
                    escaped = True
                elif char == '"':
                    in_string = False
                continue
            if char == '"':
                in_string = True
            elif char == "{":
                depth += 1
            elif char == "}":
                depth -= 1
                if depth == 0:
                    try:
                        return json.loads(text[start:i + 1])
                    except json.JSONDecodeError:
                        break
        start = text.find("{", start + 1)
    raise PolicyError(f"no JSON object in the reply: {text[:200]!r}")


def action_from_reply(text: str) -> Action:
    blob = extract_json(text)
    missing = [key for key in ("solution", "proof") if key not in blob]
    if missing:
        raise PolicyError(f"the reply is missing {missing}")
    return Action(files={SOLUTION_FILE: str(blob["solution"]),
                         PROOF_FILE: str(blob["proof"])})


# --- policies -------------------------------------------------------------------

def build_prompt(observation: dict[str, Any]) -> str:
    parts = [
        f"# Task: {observation['task_id']} (tier {observation['tier']})",
        observation["title"],
        observation["prompt"].strip(),
        "## LAWS.bend\n```\n" + observation["laws"].strip() + "\n```",
        "## solution.bend (the stub you must complete)\n```\n"
        + observation["stub"].strip() + "\n```",
        "## PROOF.bend must begin with exactly\n```\n"
        + observation["proof_header"].strip() + "\n```",
    ]
    if observation.get("prelude"):
        parts.append("## prelude.bend (already implemented, imported as P)\n```\n"
                     + observation["prelude"].strip() + "\n```")
    if observation.get("feedback"):
        parts.append("## The checker rejected your previous attempt\n```\n"
                     + observation["feedback"] + "\n```\n"
                     "Fix it. Return the whole JSON object again.")
    return "\n\n".join(parts)


@dataclass
class AnthropicPolicy:
    """One completion per turn. The model is asked for both files at once."""

    model: str = DEFAULT_MODEL
    api_key: str = field(default_factory=lambda: os.environ.get("ANTHROPIC_API_KEY", ""))
    base_url: str = field(default_factory=lambda: (
        os.environ.get("ANTHROPIC_BASE_URL") or API_URL))
    max_tokens: int = DEFAULT_MAX_TOKENS
    temperature: float = 1.0
    timeout: float = 300.0
    calls: int = 0
    input_tokens: int = 0
    output_tokens: int = 0
    errors: list[str] = field(default_factory=list)

    name = "anthropic"

    def __post_init__(self) -> None:
        if not self.api_key:
            raise PolicyError(
                "ANTHROPIC_API_KEY is not set; calibration needs one to spend")

    def complete(self, prompt: str) -> str:
        body = json.dumps({
            "model": self.model,
            "max_tokens": self.max_tokens,
            "temperature": self.temperature,
            "system": SYSTEM,
            "messages": [{"role": "user", "content": prompt}],
        }).encode()
        request = urllib.request.Request(
            self.base_url, data=body, method="POST",
            headers={"content-type": "application/json",
                     "x-api-key": self.api_key,
                     "anthropic-version": API_VERSION})
        self.calls += 1
        try:
            with urllib.request.urlopen(request, timeout=self.timeout) as response:
                payload = json.loads(response.read())
        except urllib.error.HTTPError as exc:
            detail = exc.read().decode(errors="replace")[:400]
            raise PolicyError(f"HTTP {exc.code}: {detail}") from exc
        except urllib.error.URLError as exc:
            raise PolicyError(f"the request failed: {exc.reason}") from exc

        usage = payload.get("usage", {})
        self.input_tokens += usage.get("input_tokens", 0)
        self.output_tokens += usage.get("output_tokens", 0)
        text = "".join(block.get("text", "") for block in payload.get("content", [])
                       if block.get("type") == "text")
        if not text:
            raise PolicyError(f"the reply carried no text: {payload}")
        return text

    def __call__(self, observation: dict[str, Any]) -> Action:
        return action_from_reply(self.complete(build_prompt(observation)))


@dataclass
class ScriptedPolicy:
    """A fixed reply per turn. For testing the loop, and for --dry-run."""

    replies: list[str]
    turn: int = 0
    name = "scripted"

    def __call__(self, observation: dict[str, Any]) -> Action:
        if self.turn >= len(self.replies):
            raise PolicyError("the script is exhausted")
        reply = self.replies[self.turn]
        self.turn += 1
        return action_from_reply(reply)


@dataclass
class EchoPolicy:
    """Sends the stub back untouched: the floor of the zero-shot rate."""

    name = "echo"

    def __call__(self, observation: dict[str, Any]) -> Action:
        return Action(files={SOLUTION_FILE: observation["stub"],
                             PROOF_FILE: observation["proof_header"]})


__all__ = ["API_URL", "DEFAULT_MODEL", "SYSTEM", "AnthropicPolicy", "EchoPolicy",
           "Policy", "PolicyError", "ScriptedPolicy", "action_from_reply",
           "build_prompt", "extract_json"]
