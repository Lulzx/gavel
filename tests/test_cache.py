"""The verdict cache: what it keys on, and what a hit hands back.

The key is the interesting surface. A cache that is merely fast is worthless if
it can return a verdict computed under different conditions, so most of what is
tested here is that each input to the verdict moves the key.
"""

from __future__ import annotations

from dataclasses import dataclass, replace
from pathlib import Path

import pytest

from gavel.cache import VerdictCache, mutant_corpus, verdict_key
from gavel.check import CheckConfig, check_submission
from gavel.runner import PLAIN, Limits
from gavel.tasks import PROOF_FILE, SOLUTION_FILE
from gavel.verdict import TIER_COMPLETE


@dataclass(frozen=True)
class FakeToolchain:
    """Only the three fields the key reads, so these tests need no bun."""

    version: str = "2.0.5"
    bun_version: str = "1.3.14"
    tree_hash: str = "t" * 64


def key_for(task, files, *, backend=PLAIN, limits=Limits(), toolchain=None):
    return verdict_key(task, toolchain or FakeToolchain(), files, backend, limits)


@pytest.fixture
def files():
    return {SOLUTION_FILE: "import Base\n", PROOF_FILE: "import Base\n"}


# --- the key --------------------------------------------------------------------

def test_the_same_inputs_key_the_same(make_task, files):
    assert key_for(make_task(), files) == key_for(make_task(), files)


def test_a_different_submission_is_a_different_verdict(make_task, files):
    other = dict(files)
    other[SOLUTION_FILE] = "import Base\n\ndef add(a: Nat, b: Nat) -> Nat:\n  b\n"
    assert key_for(make_task(), files) != key_for(make_task(), other)


def test_a_different_task_is_a_different_verdict(make_task, files):
    assert key_for(make_task(), files) != \
        key_for(make_task(task_id="t-other"), files)


def test_the_task_hash_moves_the_key_not_only_the_id(make_task, files):
    """Two tasks with one id and different bytes are different tasks, and the
    bank is regenerated often enough that ids are reused."""
    assert key_for(make_task(), files) != \
        key_for(make_task(hash="deadbeef"), files)


def test_a_different_toolchain_is_a_different_verdict(make_task, files):
    other = replace(FakeToolchain(), tree_hash="u" * 64)
    assert key_for(make_task(), files) != key_for(make_task(), files,
                                                 toolchain=other)


def test_the_bend_version_moves_the_key_even_at_the_same_tree_hash(make_task, files):
    other = replace(FakeToolchain(), version="2.0.6")
    assert key_for(make_task(), files) != key_for(make_task(), files,
                                                 toolchain=other)


def test_a_different_backend_is_a_different_verdict(make_task, files):
    """A verdict says which isolation produced it, so a plain run cannot be
    served as a sandboxed one."""
    class Named:
        name = "bwrap"

    assert key_for(make_task(), files) != key_for(make_task(), files,
                                                 backend=Named())


def test_the_limits_are_part_of_the_experiment(make_task, files):
    """A check allowed 10s and one allowed 1 are not the same run: the second
    one's timeout is not the first one's verdict."""
    assert key_for(make_task(), files) != \
        key_for(make_task(), files, limits=Limits(wall_ms=1_000))


def test_the_mutant_corpus_is_in_the_key(tmp_path, make_task, files):
    """The mutants live in references/, not in the task's own files, and a
    submission that reproduces one has its reward zeroed. Regenerate the corpus
    and every cached verdict for that task is answering a changed question."""
    references = tmp_path / "references"
    (references / "mutants").mkdir(parents=True)
    mutant = references / "mutants" / "add-constant-body.bend"
    mutant.write_text("def add(a: Nat, b: Nat) -> Nat:\n  b\n")

    before = key_for(make_task(references=references), files)
    mutant.write_text("def add(a: Nat, b: Nat) -> Nat:\n  a\n")
    after = key_for(make_task(references=references), files)
    assert before != after
    assert mutant_corpus(make_task(references=references)) != \
        mutant_corpus(make_task(references=tmp_path / "empty"))

    # A second mutant is a different corpus again, and the order on disk does
    # not matter.
    (references / "mutants" / "add-swap.bend").write_text("x\n")
    assert mutant_corpus(make_task(references=references)) != after


# --- storage --------------------------------------------------------------------

def test_a_miss_then_a_hit(tmp_path, make_task, files):
    cache = VerdictCache(tmp_path / "c.sqlite")
    key = key_for(make_task(), files)
    assert cache.get(key) is None
    cache.put(key, _verdict())
    hit = cache.get(key)
    assert hit is not None
    assert hit.task_id == "t-fake"
    assert cache.stats.hits == 1 and cache.stats.misses == 1


def test_the_cache_survives_a_reopen(tmp_path, make_task, files):
    path = tmp_path / "c.sqlite"
    key = key_for(make_task(), files)
    VerdictCache(path).put(key, _verdict())
    assert VerdictCache(path).get(key) is not None


def test_a_disabled_cache_stores_nothing(tmp_path, make_task, files):
    cache = VerdictCache(tmp_path / "c.sqlite", enabled=False)
    key = key_for(make_task(), files)
    cache.put(key, _verdict())
    assert cache.get(key) is None
    assert cache.rows() == 0


def test_the_distribution_counts_by_tier(tmp_path, make_task, files):
    cache = VerdictCache(tmp_path / "c.sqlite")
    cache.put("a", _verdict(tier=1))
    cache.put("b", _verdict(tier=4))
    assert cache.distribution() == {"1": 1, "4": 1}


def test_purging_one_task_leaves_the_others(tmp_path):
    cache = VerdictCache(tmp_path / "c.sqlite")
    cache.put("a", _verdict(task_id="t-one"))
    cache.put("b", _verdict(task_id="t-two"))
    assert cache.purge("t-one") == 1
    assert cache.rows() == 1


def test_purging_everything(tmp_path):
    cache = VerdictCache(tmp_path / "c.sqlite")
    cache.put("a", _verdict())
    cache.purge()
    assert cache.rows() == 0


def test_a_payload_is_byte_identical_to_a_fresh_verdict():
    """The interface the cache exists for: a hit must equal a fresh run.

    Asserted on the whole round trip rather than on the reward, because the
    thing the policy is shown on the next turn is the checker's own stderr --
    a cache that returned the right tier with the wrong words would train a
    policy to repair damage that is not there.
    """
    from gavel.verdict import CheckResult, GateResult, Verdict

    verdict = Verdict(
        task_id="t-fake", tier=3, reward=0.35, n_laws=4,
        proven=("a", "b"), failed=("c", "d"),
        gate=GateResult(ok=True, hashes=(("LAWS.bend", "aa"),)),
        checks=(CheckResult(ok=False, exit_code=1, ms=42,
                            stderr="Error: TODO found", backend="bwrap"),),
        toolchain_hash="abc", task_hash="def", submission_hash="ghi", ms=99)
    assert Verdict.from_json(verdict.to_json()) == verdict


def _verdict(tier: int = TIER_COMPLETE, task_id: str = "t-fake"):
    from gavel.verdict import Verdict

    return Verdict(task_id=task_id, tier=tier,
                   reward=1.0 if tier == 4 else 0.0, n_laws=1,
                   proven=("add_succ",) if tier == 4 else ())


# --- against the real checker ----------------------------------------------------

@pytest.mark.checker
def test_a_repeat_check_is_served_from_the_cache(tmp_path, task, toolchain):
    from gavel.tasks import submission_hash

    files = {SOLUTION_FILE: task.reference_solution,
             PROOF_FILE: task.reference_proof}
    cache = VerdictCache(tmp_path / "c.sqlite")
    config = CheckConfig(backend="plain")

    first = check_submission(task, toolchain, files, config, cache=cache)
    assert first.tier == TIER_COMPLETE
    assert first.cached is False

    second = check_submission(task, toolchain, files, config, cache=cache)
    assert second.tier == TIER_COMPLETE
    assert second.cached is True
    # Same verdict, same evidence, same submission.
    assert second.reward == first.reward
    assert second.proven == first.proven
    assert second.submission_hash == submission_hash(files)
    assert second.ms == first.ms          # the original run's, not a lookup's


@pytest.mark.checker
def test_the_cached_verdict_carries_the_checkers_own_words(tmp_path, task, toolchain):
    """A policy repairing from a cached result must see the same stderr."""
    files = {SOLUTION_FILE: task.reference_solution,
             PROOF_FILE: task.proof_header + "\ndef L.add_succ(x, y):\n  ?TODO\n"}
    cache = VerdictCache(tmp_path / "c.sqlite")
    config = CheckConfig(backend="plain")

    fresh = check_submission(task, toolchain, files, config, cache=cache)
    cached = check_submission(task, toolchain, files, config, cache=cache)
    assert fresh.checks and cached.checks
    assert cached.checks[-1].stderr == fresh.checks[-1].stderr
    assert cached.checks[-1].failure_kind == fresh.checks[-1].failure_kind
