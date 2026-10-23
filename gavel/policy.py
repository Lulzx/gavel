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
import shutil
import subprocess
import tempfile
import urllib.error
import urllib.request
from dataclasses import dataclass, field
from typing import Any, Protocol

from .env import Action
from .tasks import PROOF_FILE, SOLUTION_FILE

API_BASE = "https://api.anthropic.com"
MESSAGES_PATH = "/v1/messages"
API_URL = API_BASE + MESSAGES_PATH
API_VERSION = "2023-06-01"
DEFAULT_MODEL = "claude-opus-5-5"
DEFAULT_MAX_TOKENS = 8192

SYSTEM = """\
You are writing a proof in Bend 2.0.5, a dependently typed language with no \
tactics. Each task gives you its laws, a stub to complete, its prelude, and the \
header your proof file must begin with.

Reply with one JSON object and nothing else:

{"solution": "<full contents of solution.bend>", "proof": "<full contents of PROOF.bend>"}"""


def system_prompt(observation: dict[str, Any]) -> str:
    """The reply format, then the bank's shared primer on Bend.

    The primer used to be a short list here and a long one repeated inside
    every task prompt. It is now one file, ``tasks/PRIMER.md``, and the
    observation carries it so that a policy outside this module sees it too.
    """
    primer = (observation.get("primer") or "").strip()
    return SYSTEM + ("\n\n" + primer if primer else "")


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
    if observation.get("hints"):
        parts.append("## Hints: how the reference was written and proved\n"
                     + observation["hints"].strip())
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
        os.environ.get("ANTHROPIC_BASE_URL") or API_BASE))
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

    @property
    def endpoint(self) -> str:
        """Where the POST goes.

        ``ANTHROPIC_BASE_URL`` names a *base*, and the route is appended to it.
        Both spellings are accepted: an operator who pasted the whole URL out of
        a gateway's docs should not be punished for it, and neither should one
        who set the bare host.
        """
        if self.base_url.rstrip("/").endswith(MESSAGES_PATH):
            return self.base_url
        return self.base_url.rstrip("/") + MESSAGES_PATH

    def complete(self, prompt: str, system: str = SYSTEM) -> str:
        body = json.dumps({
            "model": self.model,
            "max_tokens": self.max_tokens,
            "temperature": self.temperature,
            "system": system,
            "messages": [{"role": "user", "content": prompt}],
        }).encode()
        request = urllib.request.Request(
            self.endpoint, data=body, method="POST",
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
        return action_from_reply(self.complete(build_prompt(observation),
                                               system_prompt(observation)))


@dataclass
class ClaudeCliPolicy:
    """One completion per turn through the ``claude`` CLI's print mode.

    For an operator whose access is a Claude account rather than an API key.
    The CLI is run with every tool disabled, the system prompt replaced, no
    settings, no session saved, and an empty working directory, so what comes
    back is a completion and not an agent's work: the model cannot run the
    checker, read the reference, or see this repository.
    """

    model: str = DEFAULT_MODEL
    binary: str = "claude"
    effort: str | None = None
    timeout: float = 900.0
    calls: int = 0
    input_tokens: int = 0
    output_tokens: int = 0
    cost_usd: float = 0.0

    name = "claude-cli"

    def __post_init__(self) -> None:
        if shutil.which(self.binary) is None:
            raise PolicyError(f"{self.binary!r} is not on PATH")

    def argv(self, system: str) -> list[str]:
        argv = [self.binary, "-p", "--model", self.model,
                "--output-format", "json", "--tools", "",
                "--system-prompt", system, "--setting-sources", "",
                "--strict-mcp-config", "--no-session-persistence"]
        if self.effort:
            argv += ["--effort", self.effort]
        return argv

    def complete(self, prompt: str, system: str = SYSTEM) -> str:
        # A nested CLI refuses to start inside a Claude Code session, and the
        # session's own variables are not this call's business either way.
        env = {k: v for k, v in os.environ.items()
               if not k.startswith(("CLAUDECODE", "CLAUDE_CODE_"))}
        self.calls += 1
        with tempfile.TemporaryDirectory(prefix="gavel-policy-") as cwd:
            try:
                proc = subprocess.run(self.argv(system), input=prompt, text=True,
                                      capture_output=True, cwd=cwd, env=env,
                                      timeout=self.timeout)
            except subprocess.TimeoutExpired as exc:
                raise PolicyError(f"the CLI timed out after {self.timeout}s") from exc
        try:
            payload = json.loads(proc.stdout)
        except json.JSONDecodeError as exc:
            detail = (proc.stderr or proc.stdout).strip()[:400]
            raise PolicyError(f"the CLI exited {proc.returncode}: {detail}") from exc
        if payload.get("is_error"):
            raise PolicyError(f"the CLI reported an error: {payload.get('result')!r}")
        usage = payload.get("usage", {})
        self.input_tokens += (usage.get("input_tokens", 0)
                              + usage.get("cache_read_input_tokens", 0)
                              + usage.get("cache_creation_input_tokens", 0))
        self.output_tokens += usage.get("output_tokens", 0)
        self.cost_usd += float(payload.get("total_cost_usd") or 0.0)
        text = payload.get("result") or ""
        if not text:
            raise PolicyError(f"the reply carried no text: {payload}")
        return text

    def __call__(self, observation: dict[str, Any]) -> Action:
        return action_from_reply(self.complete(build_prompt(observation),
                                               system_prompt(observation)))


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


__all__ = ["API_BASE", "API_URL", "DEFAULT_MODEL", "MESSAGES_PATH", "SYSTEM",
           "AnthropicPolicy", "ClaudeCliPolicy", "EchoPolicy", "Policy", "PolicyError",
           "ScriptedPolicy", "action_from_reply", "build_prompt", "extract_json",
           "system_prompt"]
