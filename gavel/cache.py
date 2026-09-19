"""A sqlite memo of verdicts, keyed by everything the verdict depends on.

Two things make this worth having rather than merely convenient. A 10k-episode
soak repeats the same submission across rollouts, and the per-law fixed point
re-runs isolation proofs that a previous turn already ran -- the checker is the
expensive part of an episode, and it is a pure function of its inputs. And a
calibration run re-submits one task k times, where the *interesting* variation
is the policy, not the checker.

Soundness rests on the key. A verdict is a function of the task's bytes, the
submission's bytes, the toolchain tree, the backend, and the limits; anything
left out of the key is a way to serve a verdict computed under different
conditions. So the key is a hash of all of them, and the version of the cache
format is in the key too -- a schema change invalidates rather than misreads.

The checker is deterministic in what it *decides* and not in how long it takes,
so a hit keeps the original ``ms`` and marks itself: a latency distribution
built out of cache hits would be a distribution of how long it took to look
something up.
"""

from __future__ import annotations

import json
import sqlite3
import threading
import time
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

from .hashing import hash_files, sha256_file, sha256_text
from .runner import Backend, Limits
from .tasks import Task
from .toolchain import Toolchain
from .verdict import Verdict

# Bumping this invalidates every row. It is part of the key rather than a
# migration because the old rows are worthless: a verdict whose meaning changed
# is not a verdict.
SCHEMA = 4


@dataclass
class CacheStats:
    hits: int = 0
    misses: int = 0
    stored: int = 0
    _lock: threading.Lock = field(default_factory=threading.Lock, repr=False)

    def hit(self) -> None:
        with self._lock:
            self.hits += 1

    def miss(self) -> None:
        with self._lock:
            self.misses += 1

    def store(self) -> None:
        with self._lock:
            self.stored += 1

    def snapshot(self) -> tuple[int, int, int]:
        """All three under one lock, so a report cannot show a hit counted
        against a miss not yet counted -- the totals must add up."""
        with self._lock:
            return self.hits, self.misses, self.stored

    @property
    def total(self) -> int:
        hits, misses, _ = self.snapshot()
        return hits + misses

    @property
    def hit_rate(self) -> float:
        hits, misses, _ = self.snapshot()
        total = hits + misses
        return hits / total if total else 0.0

    def to_json(self) -> dict[str, Any]:
        hits, misses, stored = self.snapshot()
        total = hits + misses
        return {"hits": hits, "misses": misses, "stored": stored,
                "lookups": total,
                "hit_rate": round(hits / total, 4) if total else 0.0}


def mutant_corpus(task: Task) -> str:
    """A digest of the task's mutants, which the verdict also depends on.

    Easy to miss, because the mutants live in ``references/`` rather than in the
    task's own files: a mutant whose solution the submission reproduces zeroes
    the reward (SPEC.md 7.4.2). Regenerate the corpus and every cached verdict
    for that task is answering a question that has changed, so the corpus is in
    the key beside the task's own bytes.
    """
    return sha256_text(json.dumps(
        [[path.name, sha256_file(path)] for path in task.mutant_paths],
        sort_keys=True))


def verdict_key(task: Task, toolchain: Toolchain, files: dict[str, str],
                backend: Backend, limits: Limits, *,
                attribute_partial: bool = True, max_runs: int = 64) -> str:
    """Everything a verdict is a function of, and nothing else.

    ``limits`` is in the key on purpose: a run that was allowed 10 seconds and a
    run that was allowed 1 are different experiments, and the second one's
    timeout is not the first one's verdict. ``attribute_partial`` and
    ``max_runs`` are the two ``CheckConfig`` fields that move a verdict without
    moving a limit: with attribution off a partial submission reads tier 2,
    and a lower run cap can stop the fixed point short of a law it would have
    credited. The defaults mirror ``CheckConfig``; ``check_submission`` passes
    its own values explicitly.
    """
    return sha256_text(json.dumps({
        "schema": SCHEMA,
        "protocol": [bool(attribute_partial), int(max_runs)],
        "task": task.task_id,
        "task_hash": task.hash,
        "mutants": mutant_corpus(task),
        "toolchain": toolchain.tree_hash,
        "bend": toolchain.version,
        "bun": toolchain.bun_version,
        "backend": backend.name,
        "limits": [limits.wall_ms, limits.memory_bytes, limits.nproc,
                   limits.cpu_seconds, limits.output_bytes],
        "files": hash_files(files),
    }, sort_keys=True))


class VerdictCache:
    """A file-backed memo. One process, one file; WAL so a reader can look.

    Thread-safe, and not only because sqlite is: one connection used from
    several threads lets two transactions interleave on it, which sqlite
    reports as a cursor error on one of them. The lock is per-process and the
    connection is shared, which is the point -- a connection per worker would
    make the cache a database per worker and the hit rate an artefact of how
    the work was split.
    """

    def __init__(self, path: Path | str = "gavel-cache.sqlite",
                 enabled: bool = True) -> None:
        self.path = Path(path)
        self.enabled = enabled
        self.stats = CacheStats()
        self._db: sqlite3.Connection | None = None
        self._lock = threading.Lock()
        if enabled:
            self._open()

    def _open(self) -> None:
        if self.path.parent and str(self.path.parent) not in ("", "."):
            self.path.parent.mkdir(parents=True, exist_ok=True)
        # check_same_thread=False: the batch helper checks verdicts in a thread
        # pool, and a connection per process would mean a database per worker.
        # sqlite serialises writes itself; the cost of sharing is far below the
        # cost of the check being avoided.
        self._db = sqlite3.connect(str(self.path), check_same_thread=False)
        self._db.execute("PRAGMA journal_mode=WAL")
        self._db.execute(
            "CREATE TABLE IF NOT EXISTS verdicts ("
            " key TEXT PRIMARY KEY,"
            " task_id TEXT NOT NULL,"
            " tier INTEGER NOT NULL,"
            " reward REAL NOT NULL,"
            " toolchain TEXT NOT NULL,"
            " payload TEXT NOT NULL,"
            " created REAL NOT NULL"
            ")")
        self._db.commit()

    # --- the two methods that matter ------------------------------------------

    def get(self, key: str) -> Verdict | None:
        if not self.enabled or self._db is None:
            return None
        with self._lock:
            row = self._db.execute("SELECT payload FROM verdicts WHERE key = ?",
                                   (key,)).fetchone()
        if row is None:
            self.stats.miss()
            return None
        self.stats.hit()
        return Verdict.from_json(json.loads(row[0]))

    def put(self, key: str, verdict: Verdict) -> None:
        if not self.enabled or self._db is None:
            return
        with self._lock:
            self._db.execute(
                "INSERT OR REPLACE INTO verdicts "
                "(key, task_id, tier, reward, toolchain, payload, created) "
                "VALUES (?, ?, ?, ?, ?, ?, ?)",
                (key, verdict.task_id, verdict.tier, verdict.reward,
                 verdict.toolchain_hash, json.dumps(verdict.to_json()),
                 time.time()))
            self._db.commit()
        self.stats.store()

    # --- maintenance -----------------------------------------------------------

    def rows(self) -> int:
        if not self.enabled or self._db is None:
            return 0
        with self._lock:
            return int(self._db.execute(
                "SELECT COUNT(*) FROM verdicts").fetchone()[0])

    def distribution(self) -> dict[str, int]:
        """How many cached verdicts there are per tier.

        A cache that only ever holds tier 1 is a cache of the cheap case; the
        interesting question is whether the expensive full runs are in it.
        """
        if not self.enabled or self._db is None:
            return {}
        with self._lock:
            rows = self._db.execute(
                "SELECT tier, COUNT(*) FROM verdicts GROUP BY tier ORDER BY tier")
            return {str(tier): count for tier, count in rows}

    def purge(self, task_id: str | None = None) -> int:
        if not self.enabled or self._db is None:
            return 0
        with self._lock:
            if task_id is None:
                cursor = self._db.execute("DELETE FROM verdicts")
            else:
                cursor = self._db.execute(
                    "DELETE FROM verdicts WHERE task_id = ?", (task_id,))
            self._db.commit()
            return cursor.rowcount

    def close(self) -> None:
        with self._lock:
            if self._db is not None:
                self._db.close()
                self._db = None

    def __enter__(self) -> "VerdictCache":
        return self

    def __exit__(self, *exc: object) -> None:
        self.close()

    def to_json(self) -> dict[str, Any]:
        return {**self.stats.to_json(), "rows": self.rows(),
                "path": str(self.path), "enabled": self.enabled}


__all__ = ["SCHEMA", "CacheStats", "VerdictCache", "mutant_corpus", "verdict_key"]
