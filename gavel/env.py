"""The episode protocol of SPEC.md 6.

    reset(task_id | sampler) -> Observation
    step(Action)             -> (Observation, reward, done, info)
    close()

In-process and transport-agnostic: the harness owns no threads and no server,
so an episode is a function call. ``gavel/server.py`` (M3) wraps this for other
stacks rather than reimplementing it.

Turns are independent submissions. Nothing carries over between them except
the feedback text, which is the checker's own words rather than a summary of
them -- Bend's terse errors are the signal a policy learns to repair from.
"""

from __future__ import annotations

import random
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Callable, Iterator

from .check import CheckConfig, check_submission
from .reward import dense_delta
from .tasks import (SUBMITTED_FILES, Manifest, Task, TaskError, load_manifest)
from .toolchain import DEFAULT_VERSION, Toolchain
from .verdict import TIER_COMPLETE, Verdict

DEFAULT_MAX_TURNS = 4
DEFAULT_FEEDBACK_BYTES = 2048

Sampler = Callable[[Manifest, random.Random], Task]


class EnvError(RuntimeError):
    pass


@dataclass(frozen=True)
class Action:
    """A submission: one entry per file the policy is allowed to write."""

    files: dict[str, str]

    def __post_init__(self) -> None:
        unknown = sorted(set(self.files) - set(SUBMITTED_FILES))
        if unknown:
            raise EnvError(
                f"a submission may contain only {list(SUBMITTED_FILES)}; "
                f"got {unknown}. The gate rejects these for reward, but an "
                f"action that cannot be scored is better refused here.")


@dataclass
class GavelEnv:
    manifest: Manifest
    toolchain: Toolchain
    mode: str = "dense"
    """``dense`` pays the improvement over the best turn so far (SPEC.md 8,
    note 3); ``sparse`` pays nothing until the episode ends."""

    max_turns: int = DEFAULT_MAX_TURNS
    feedback_bytes: int = DEFAULT_FEEDBACK_BYTES
    sampler: Sampler | None = None
    config: CheckConfig = field(default_factory=CheckConfig)
    seed: int | None = None

    task: Task | None = field(default=None, init=False)
    turn: int = field(default=0, init=False)
    best: float = field(default=0.0, init=False)
    history: list[Verdict] = field(default_factory=list, init=False)
    _rng: random.Random = field(default=None, init=False, repr=False)

    def __post_init__(self) -> None:
        if self.mode not in ("dense", "sparse"):
            raise EnvError(f"mode must be 'dense' or 'sparse', not {self.mode!r}")
        if self.max_turns < 1:
            raise EnvError("max_turns must be at least 1")
        self._rng = random.Random(self.seed)

    @classmethod
    def from_manifest(cls, path: Path | str = "manifest.json", **kwargs: Any) -> "GavelEnv":
        manifest = load_manifest(Path(path))
        toolchain = Toolchain.load(manifest.bend_version or DEFAULT_VERSION)
        return cls(manifest=manifest, toolchain=toolchain, **kwargs)

    # --- episode lifecycle ----------------------------------------------------

    def reset(self, task_id: str | None = None) -> dict[str, Any]:
        """Begin an episode. ``task_id`` of None samples."""
        self.task = self._pick(task_id)
        self.turn = 0
        self.best = 0.0
        self.history = []
        return self._observation(feedback=None)

    def step(self, action: Action) -> tuple[dict[str, Any], float, bool, Verdict]:
        if self.task is None:
            raise EnvError("step() before reset()")
        if self.turn >= self.max_turns:
            raise EnvError(
                f"episode for {self.task.task_id} is over; call reset()")

        self.turn += 1
        verdict = check_submission(self.task, self.toolchain, action.files,
                                   self.config)
        self.history.append(verdict)

        reward = self._reward(verdict)
        done = verdict.solved or self.turn >= self.max_turns
        self.best = max(self.best, verdict.reward)

        observation = self._observation(
            feedback=None if done else self._feedback(verdict))
        return observation, reward, done, verdict

    def close(self) -> None:
        """No persistent resources yet: every check cleans up its own workdir.

        Kept because the API is Gym-shaped and the M3 worker pool will need it.
        """
        self.task = None
        self.history = []

    # --- reward ---------------------------------------------------------------

    def _reward(self, verdict: Verdict) -> float:
        if self.mode == "sparse":
            return verdict.reward if verdict.solved else 0.0
        return dense_delta(self.best, verdict.reward)

    # --- observations ---------------------------------------------------------

    def _observation(self, feedback: str | None) -> dict[str, Any]:
        assert self.task is not None
        return self.task.observation(turn=self.turn + 1, max_turns=self.max_turns,
                                     feedback=feedback)

    def _feedback(self, verdict: Verdict) -> str:
        """The checker's words plus the gate's, which is all a policy gets."""
        parts: list[str] = []
        if verdict.gate is not None and not verdict.gate.ok:
            parts.append("\n".join(f"- {finding}" for finding in verdict.gate.findings))
        if verdict.checks:
            parts.append(verdict.checks[-1].feedback(self.feedback_bytes))
        text = "\n".join(part for part in parts if part).strip()
        return text or f"tier {verdict.tier}: no diagnostic was produced"

    # --- sampling --------------------------------------------------------------

    def _pick(self, task_id: str | None) -> Task:
        if task_id is not None:
            return self.manifest.get(task_id)
        if self.sampler is not None:
            return self.sampler(self.manifest, self._rng)
        if not len(self.manifest):
            raise TaskError(f"no tasks in {self.manifest.path}")
        return self._rng.choice(list(self.manifest))

    def __iter__(self) -> Iterator[Task]:
        return iter(self.manifest)


def uniform_sampler(manifest: Manifest, rng: random.Random) -> Task:
    return rng.choice(list(manifest))


def tier_sampler(tiers: tuple[int, ...]) -> Sampler:
    """Sample only from the given tiers -- the curriculum hook of SPEC.md 11."""
    def sample(manifest: Manifest, rng: random.Random) -> Task:
        pool = [t for t in manifest if t.tier in tiers]
        if not pool:
            raise TaskError(f"no tasks in tiers {tiers}")
        return rng.choice(pool)
    return sample


def easiest_first(manifest: Manifest, rng: random.Random) -> Task:
    """Always take an unsolved-in-this-session task from the lowest tier."""
    tasks = sorted(manifest, key=lambda t: (t.tier, t.task_id))
    return tasks[0] if tasks else rng.choice(list(manifest))
