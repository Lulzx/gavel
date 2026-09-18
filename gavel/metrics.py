"""What a run adds up to, accumulated as it goes.

Everything here is derived from the episode records rather than kept beside
them, so the report cannot disagree with the log: :func:`summarise` takes the
same records ``Trajectory`` writes and produces the same numbers a live
``Metrics`` would. The live object exists only so that a run of ten thousand
episodes can be watched without re-reading the file.

The one place this is opinionated is latency. The checker's wall time is
bimodal -- a submission that fails to parse returns in milliseconds, a
submission that proves every law runs the whole per-law fixed point -- so a mean
is meaningless and the interesting numbers are the tail. Percentiles are
computed over *fresh* checks only: a cache hit carries the original run's ``ms``
and a distribution built from those is a distribution of how long it takes to
look something up.
"""

from __future__ import annotations

import json
import threading
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Iterable

from .trajectory import EpisodeRecord

# Nearest-rank percentiles, which need no interpolation and therefore cannot
# report a latency that no check ever took.
DEFAULT_PERCENTILES = (50, 90, 95, 99)


def percentile(values: list[float], pct: float) -> float:
    """Nearest-rank. ``values`` must be non-empty."""
    if not values:
        raise ValueError("percentile of an empty sample")
    ordered = sorted(values)
    if pct <= 0:
        return ordered[0]
    rank = max(1, min(len(ordered), int(-(-len(ordered) * pct // 100))))
    return ordered[rank - 1]


@dataclass
class Metrics:
    """Live counters for a run, updated one episode at a time."""

    episodes: int = 0
    solved: int = 0
    turns: int = 0
    reward: float = 0.0
    by_tier: dict[int, int] = field(default_factory=dict)
    """Where episodes *ended*, not where their turns landed."""

    turn_tiers: dict[int, int] = field(default_factory=dict)
    """Where individual turns landed -- the histogram that shows a curriculum
    is actually being climbed rather than merely being attempted."""

    fresh_ms: list[int] = field(default_factory=list)
    """Wall time of checks this process actually ran, in order."""

    cache_hits: int = 0
    gate_rejections: int = 0
    incidents: int = 0
    """Submissions that reproduced a mutant's own solution. Should be zero; a
    nonzero count means V2 let a task through."""

    _lock: threading.Lock = field(default_factory=threading.Lock, repr=False)

    @property
    def solve_rate(self) -> float:
        return self.solved / self.episodes if self.episodes else 0.0

    @property
    def mean_reward(self) -> float:
        return self.reward / self.episodes if self.episodes else 0.0

    @property
    def mean_turns(self) -> float:
        return self.turns / self.episodes if self.episodes else 0.0

    def add(self, episode: EpisodeRecord) -> None:
        """One episode, from one thread. A server shares one report across
        sessions, so the counters are updated under a lock -- a report that
        loses an episode to a race is a report that disagrees with its own log."""
        with self._lock:
            self._add(episode)

    def _add(self, episode: EpisodeRecord) -> None:
        self.episodes += 1
        self.turns += episode.turns_used
        self.reward += episode.total_reward
        if episode.solved:
            self.solved += 1
        self.by_tier[episode.best_tier] = self.by_tier.get(episode.best_tier, 0) + 1
        for turn in episode.turns:
            self.turn_tiers[turn.verdict.tier] = \
                self.turn_tiers.get(turn.verdict.tier, 0) + 1
            if turn.verdict.cached:
                self.cache_hits += 1
            elif turn.verdict.checks:
                self.fresh_ms.append(turn.verdict.checks[-1].ms)
            gate = turn.verdict.gate
            if gate is not None and not gate.ok:
                self.gate_rejections += 1
            if turn.verdict.incident is not None:
                self.incidents += 1

    def latencies(self, percentiles: Iterable[int] = DEFAULT_PERCENTILES
                  ) -> dict[str, float]:
        if not self.fresh_ms:
            return {}
        return {f"p{p}": percentile([float(ms) for ms in self.fresh_ms], p)
                for p in percentiles}

    def to_json(self) -> dict[str, Any]:
        """A snapshot. Taken under the lock because it sorts the histograms,
        and iterating a dict another thread is inserting into raises."""
        with self._lock:
            return self._snapshot()

    def _snapshot(self) -> dict[str, Any]:
        return {
            "episodes": self.episodes,
            "solved": self.solved,
            "solve_rate": round(self.solve_rate, 4),
            "mean_reward": round(self.mean_reward, 4),
            "mean_turns": round(self.mean_turns, 4),
            "turns": self.turns,
            "by_tier": {str(k): v for k, v in sorted(self.by_tier.items())},
            "turn_tiers": {str(k): v for k, v in sorted(self.turn_tiers.items())},
            "cache_hits": self.cache_hits,
            "gate_rejections": self.gate_rejections,
            "incidents": self.incidents,
            "fresh_checks": len(self.fresh_ms),
            "latency_ms": self.latencies(),
        }

    def write(self, path: Path | str) -> None:
        Path(path).write_text(json.dumps(self.to_json(), indent=2) + "\n",
                              encoding="utf-8")


def summarise(episodes: Iterable[EpisodeRecord]) -> Metrics:
    """The same numbers, from a log. This is how a finished soak is read."""
    metrics = Metrics()
    for episode in episodes:
        metrics.add(episode)
    return metrics


__all__ = ["DEFAULT_PERCENTILES", "Metrics", "percentile", "summarise"]
