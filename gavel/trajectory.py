"""Episode logs: one JSON object per line, append-only.

JSONL rather than a single JSON document because episodes are long and arrive
one at a time. A soak that dies at episode 9,000 leaves 8,999 readable records
instead of a truncated file that parses as nothing, and a reader can stream a
multi-gigabyte log without holding it.

The record keeps the *verdict*, not a summary of it. A trajectory is the raw
material for every later question -- reward shaping, feedback ablation,
per-law difficulty -- and each of those wants a field that a summary would have
thrown away. The one thing it deliberately does not keep by default is the
submitted source: it is the largest field, it is recoverable from
``submission_hash`` when the policy's own logs are kept, and a log that
faithfully records every failed attempt is also a log full of whatever a model
typed. ``store_actions=True`` opts in for a run that needs it.
"""

from __future__ import annotations

import json
import threading
import time
import uuid
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Iterator

from .verdict import Verdict


def _new_run_id() -> str:
    """Time-ordered enough to sort, random enough not to collide.

    The prefix is UTC so a directory of logs lists chronologically by name; the
    suffix is what makes two runs started in the same second distinguishable.
    """
    return time.strftime("%Y%m%dT%H%M%SZ", time.gmtime()) + "-" + uuid.uuid4().hex[:8]


@dataclass
class TurnRecord:
    """One submission and what the checker made of it."""

    turn: int
    reward: float
    done: bool
    verdict: Verdict
    files: dict[str, str] | None = None

    def to_json(self) -> dict[str, Any]:
        blob: dict[str, Any] = {
            "turn": self.turn,
            "reward": self.reward,
            "done": self.done,
            "tier": self.verdict.tier,
            "verdict": self.verdict.to_json(),
        }
        if self.files is not None:
            blob["files"] = dict(self.files)
        return blob

    @classmethod
    def from_json(cls, blob: dict[str, Any]) -> "TurnRecord":
        return cls(turn=blob["turn"], reward=blob["reward"], done=blob["done"],
                   verdict=Verdict.from_json(blob["verdict"]),
                   files=blob.get("files"))


@dataclass
class EpisodeRecord:
    """One episode: a task, the turns spent on it, and what it paid.

    Carries the run, the bank, and the checker version at the episode level
    (SPEC.md 13.1 puts them on every turn; they do not change within a run, so
    repeating them per turn would be noise). They are not decoration: a reward
    is only meaningful against a named bank checked by a named toolchain, and a
    log that omits them is a log whose numbers cannot be compared to anything
    written after the next Bend release.
    """

    episode: int
    task_id: str
    tier: int
    mode: str
    turns: list[TurnRecord] = field(default_factory=list)
    seed: int | None = None
    ms: int = 0
    at: float = field(default_factory=time.time)
    run_id: str = ""
    bank_hash: str = ""
    bend_version: str = ""

    @property
    def episode_id(self) -> str:
        """Stable within a run, and the pair is stable across runs that share a
        bank: ``run_id`` alone would collide between two sweeps."""
        return f"{self.run_id}:{self.episode}" if self.run_id else str(self.episode)

    @property
    def total_reward(self) -> float:
        return sum(turn.reward for turn in self.turns)

    @property
    def turns_used(self) -> int:
        return len(self.turns)

    @property
    def solved(self) -> bool:
        return any(turn.verdict.solved for turn in self.turns)

    @property
    def best_tier(self) -> int:
        """The best the policy reached, which is not the last thing it tried.

        A policy that solves on turn 2 and keeps submitting is *solved*; reading
        the final turn would call it a regression.
        """
        return max((turn.verdict.tier for turn in self.turns), default=0)

    @property
    def cache_hits(self) -> int:
        return sum(1 for turn in self.turns if turn.verdict.cached)

    def to_json(self) -> dict[str, Any]:
        return {
            "episode": self.episode,
            "episode_id": self.episode_id,
            "run_id": self.run_id,
            "task_id": self.task_id,
            "tier": self.tier,
            "mode": self.mode,
            "bank_hash": self.bank_hash,
            "bend_version": self.bend_version,
            "seed": self.seed,
            "turns_used": self.turns_used,
            "solved": self.solved,
            "total_reward": self.total_reward,
            "best_tier": self.best_tier,
            "cache_hits": self.cache_hits,
            "ms": self.ms,
            "at": self.at,
            "turns": [turn.to_json() for turn in self.turns],
        }

    @classmethod
    def from_json(cls, blob: dict[str, Any]) -> "EpisodeRecord":
        return cls(episode=blob["episode"], task_id=blob["task_id"],
                   tier=blob["tier"], mode=blob["mode"],
                   seed=blob.get("seed"), ms=blob.get("ms", 0),
                   at=blob.get("at", 0.0), run_id=blob.get("run_id", ""),
                   bank_hash=blob.get("bank_hash", ""),
                   bend_version=blob.get("bend_version", ""),
                   turns=[TurnRecord.from_json(t) for t in blob.get("turns", [])])


class Trajectory:
    """Append-only JSONL, opened lazily so an env can be built without a path."""

    def __init__(self, path: Path | str = "trajectory.jsonl",
                 store_actions: bool = False, run_id: str | None = None) -> None:
        self.path = Path(path)
        self.store_actions = store_actions
        self.run_id = run_id or _new_run_id()
        self._fh = None
        self.episodes_written = 0
        # Two threads appending whole lines to one file is exactly the way to
        # get a spliced line that parses as neither record.
        self._lock = threading.Lock()

    def _handle(self):
        if self._fh is None:
            if self.path.parent and str(self.path.parent) not in ("", "."):
                self.path.parent.mkdir(parents=True, exist_ok=True)
            self._fh = self.path.open("a", encoding="utf-8")
        return self._fh

    def write(self, episode: EpisodeRecord) -> None:
        """One episode, one line, flushed.

        Flushed per line rather than buffered: the point of the format is to
        survive a crash, and a record sitting in a buffer when the process dies
        is a record that did not survive anything.
        """
        if not episode.run_id:
            episode.run_id = self.run_id
        line = json.dumps(episode.to_json()) + "\n"
        with self._lock:
            handle = self._handle()
            handle.write(line)
            handle.flush()
            self.episodes_written += 1

    def close(self) -> None:
        with self._lock:
            if self._fh is not None:
                self._fh.close()
                self._fh = None

    def __enter__(self) -> "Trajectory":
        return self

    def __exit__(self, *exc: object) -> None:
        self.close()

    # --- reading ---------------------------------------------------------------

    def read(self) -> Iterator[EpisodeRecord]:
        """Every complete line. A half-written final line is skipped, not fatal.

        That is the whole reason for the format: a killed soak should still be
        worth reading.
        """
        if not self.path.exists():
            return
        with self.path.open(encoding="utf-8") as handle:
            for line in handle:
                line = line.strip()
                if not line:
                    continue
                try:
                    blob = json.loads(line)
                except json.JSONDecodeError:
                    continue
                yield EpisodeRecord.from_json(blob)

    def rows(self) -> int:
        return sum(1 for _ in self.read())


def replay(path: Path | str) -> list[EpisodeRecord]:
    return list(Trajectory(path).read())


__all__ = ["EpisodeRecord", "Trajectory", "TurnRecord", "replay"]
