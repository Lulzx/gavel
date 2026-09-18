"""The scripted soak: what it draws, and what it refuses to report.

Everything here is about the policy the soak uses rather than the checker, so
none of it needs the checker and none of it is marked. The one property that
does need a real run -- that an episode is a function of its index, so the same
seed gives the same episodes at any ``--jobs`` -- is the reason the drawing is
done from ``Random(seed + index)`` in the first place, and is checked by
``test_the_same_seed_draws_the_same_episodes_whatever_the_jobs``.
"""

from __future__ import annotations

import random
from collections import Counter
from pathlib import Path

import pytest

from gavel.metrics import Metrics
from gavel.tasks import PROOF_FILE, SOLUTION_FILE
from gavel.trajectory import EpisodeRecord, Trajectory, TurnRecord
from gavel.verdict import TIER_CHECKS, TIER_COMPLETE
from tools.soak import (CLIMB, FAIL, GATE, audit, choose, jitter, repertoire,
                        script, throughput)

# --- what an episode draws -----------------------------------------------------

@pytest.mark.parametrize("family", [CLIMB, FAIL, GATE])
def test_every_script_is_within_the_turn_budget(task, family):
    rng = random.Random(1)
    for _ in range(20):
        attempts = script(task, family, 3, rng)
        assert 1 <= len(attempts) <= 3


def test_a_climb_script_ends_on_the_answer(task):
    rng = random.Random(0)
    for _ in range(50):
        attempts = script(task, CLIMB, 4, rng)
        assert attempts[-1].files[PROOF_FILE] == task.reference_proof
        assert attempts[-1].files[SOLUTION_FILE] == task.reference_solution


def test_a_climb_does_not_always_spend_the_whole_budget(task):
    """A policy that has learned a task solves it early, and ``done`` before
    the budget is spent is a path through ``GavelEnv.step`` that a soak of
    nothing but full-length episodes would never exercise."""
    lengths = {len(script(task, CLIMB, 4, random.Random(seed)))
               for seed in range(200)}
    assert lengths == {1, 2, 3, 4}


def test_a_fail_script_only_ever_submits_wrong_solutions(task):
    """The family is named for what it cannot do: reach tier 4."""
    attempts = script(task, FAIL, 4, random.Random(0))
    assert len(attempts) == 4
    for attempt in attempts:
        assert attempt.files[SOLUTION_FILE] != task.reference_solution


def test_the_repertoire_comes_from_the_task(task):
    made = repertoire(task)
    assert set(made) == {CLIMB, FAIL, GATE}
    assert made[CLIMB][-1].files[SOLUTION_FILE] == task.reference_solution
    assert made[GATE][0].files[PROOF_FILE] != task.reference_proof


def test_a_task_with_no_mutants_still_has_a_fail_family(make_task, task, tmp_path):
    """``fail`` falls back to the rungs, because an empty pool would make the
    modulo in ``script`` raise rather than produce a shorter episode. V2
    requires mutants, so this is a task that should not exist -- and it is
    exactly the input a generator is most likely to be handed."""
    bare = tmp_path / "bare"
    bare.mkdir()
    (bare / SOLUTION_FILE).write_text(task.reference_solution)
    (bare / PROOF_FILE).write_text(task.reference_proof)
    made = make_task(references=bare)
    assert made.mutant_paths == ()
    assert repertoire(made)[FAIL]


def test_the_families_are_drawn_in_rough_proportion():
    rng = random.Random(0)
    counts = Counter(choose(rng) for _ in range(10_000))
    assert counts[CLIMB] / 10_000 == pytest.approx(0.5, abs=0.02)
    assert counts[FAIL] / 10_000 == pytest.approx(0.4, abs=0.02)
    assert counts[GATE] == 10_000 - counts[CLIMB] - counts[FAIL]


# --- the jitter ----------------------------------------------------------------

def test_the_jitter_changes_the_bytes_and_nothing_else():
    files = {SOLUTION_FILE: "import Base\n", PROOF_FILE: "import Base\n"}
    marked = jitter(files, 7)
    assert set(marked) == set(files)
    for name, text in marked.items():
        assert text.startswith(files[name])       # appended, so the program is
        assert text != files[name]                # the same and the key is not


def test_two_turns_never_get_the_same_jitter():
    """Otherwise a rung the script repeats hits the entry its own previous
    submission wrote, and ``noisy`` does not mean every turn was checked."""
    one = jitter({SOLUTION_FILE: "import Base\n"}, 0 * 4 + 0)
    two = jitter({SOLUTION_FILE: "import Base\n"}, 0 * 4 + 1)
    assert one != two


# --- reporting -----------------------------------------------------------------

def test_throughput_divides_by_the_jobs_it_used():
    metrics = Metrics(episodes=100, turns=600)
    got = throughput(metrics, 60.0, 4)
    assert got["verdicts_per_min"] == 600.0
    assert got["verdicts_per_min_per_core"] == 150.0
    assert got["episodes_per_min"] == 100.0


def test_throughput_survives_a_run_that_took_no_time():
    """A fully cached soak finishes inside a rounding error of zero seconds,
    and 600/0 is not a number a report should contain."""
    got = throughput(Metrics(episodes=10, turns=10), 0.0, 0)
    assert got["verdicts_per_min"] == 0.0
    assert got["verdicts_per_min_per_core"] == 0.0
    assert got["jobs"] == 1


# --- the log is checked against the run ----------------------------------------

class _Log:
    """A trajectory that reads back records held in memory."""

    def __init__(self, episodes: list[EpisodeRecord]) -> None:
        self._episodes = episodes

    def read(self):
        return iter(self._episodes)


def _episode(index: int, tier: int, incident: str | None = None) -> EpisodeRecord:
    verdict = {"task_id": "t", "tier": tier, "reward": 0.0, "n_laws": 1,
               "incident": incident}
    from gavel.verdict import Verdict
    return EpisodeRecord(
        episode=index, task_id="t", tier=1, mode="dense",
        turns=[TurnRecord(turn=1, reward=0.0, done=True,
                          verdict=Verdict.from_json(verdict))])


def test_an_incident_the_script_asked_for_is_not_reported_as_a_hole():
    """The ``fail`` family submits mutants on purpose, and any that reaches a
    proving tier is an incident by design. Counting those would make every
    soak report a V2 hole."""
    records = [_episode(0, TIER_COMPLETE, incident="mutant:broken"),
               _episode(1, TIER_COMPLETE, incident="mutant:broken")]
    live = Metrics()
    for record in records:
        live.add(record)
    logged = audit(_Log(records), live, {0: FAIL, 1: FAIL})
    assert logged["incidents_unexpected"] == 0
    assert logged["incidents_by_family"] == {FAIL: 2}


def test_an_incident_the_script_did_not_ask_for_is_reported():
    records = [_episode(0, TIER_COMPLETE, incident="mutant:broken")]
    live = Metrics()
    for record in records:
        live.add(record)
    logged = audit(_Log(records), live, {0: CLIMB})
    assert logged["incidents_unexpected"] == 1


def test_a_log_that_lost_an_episode_is_caught():
    """``metrics.py`` claims a live run and the same run read back cannot
    disagree. That is the claim this checks, and a soak is the only place big
    enough for it to be worth checking."""
    records = [_episode(0, TIER_COMPLETE), _episode(1, TIER_CHECKS)]
    live = Metrics()
    for record in records:
        live.add(record)
    logged = audit(_Log(records[:1]), live, {})
    assert any("episodes" in line for line in logged["disagreements"])


def test_a_log_that_agrees_reports_nothing():
    records = [_episode(0, TIER_COMPLETE), _episode(1, TIER_CHECKS)]
    live = Metrics()
    for record in records:
        live.add(record)
    logged = audit(_Log(records), live, {0: CLIMB, 1: FAIL})
    assert logged["disagreements"] == []


# --- the property the whole design rests on ------------------------------------

@pytest.mark.checker
def test_the_same_seed_draws_the_same_episodes_whatever_the_jobs(
        manifest, toolchain, tmp_path):
    """Every episode's task and script come from ``Random(seed + index)``, so
    a run is a function of its seed and not of how it was parallelised.

    A soak whose contents depend on the worker count cannot be compared to a
    re-run of itself, which is the only comparison a soak is for -- and the
    failure is invisible, because both runs look perfectly healthy.
    """
    from gavel.cache import VerdictCache
    from tools.soak import Soak

    cache = VerdictCache(tmp_path / "cache.sqlite")

    def draw(jobs: int) -> dict[int, tuple[str, list[int]]]:
        path = tmp_path / f"trajectory-{jobs}.jsonl"
        soak = Soak(manifest=manifest, toolchain=toolchain, episodes=4, seed=3,
                    jobs=jobs, policy="scripted", cache=cache,
                    trajectory=Trajectory(path))
        soak.run()
        soak.trajectory.close()
        return {episode.episode: (episode.task_id,
                                  [turn.verdict.tier for turn in episode.turns])
                for episode in Trajectory(path).read()}

    one, three = draw(1), draw(3)
    cache.close()
    assert len(one) == 4
    assert one == three


@pytest.mark.checker
def test_a_soak_run_reconciles_its_log_with_its_counters(manifest, toolchain,
                                                         tmp_path):
    """The end-to-end version of the audit: a real run, and a log that agrees
    with the report the run produced while it was happening."""
    from gavel.cache import VerdictCache
    from gavel.metrics import summarise
    from tools.soak import Soak

    cache = VerdictCache(tmp_path / "cache.sqlite")
    path = tmp_path / "trajectory.jsonl"
    soak = Soak(manifest=manifest, toolchain=toolchain, episodes=4, seed=5,
                jobs=2, policy="scripted", cache=cache,
                trajectory=Trajectory(path))
    soak.run()
    soak.trajectory.close()
    logged = audit(Trajectory(path), soak.metrics, soak.families)
    cache.close()

    assert logged["disagreements"] == []
    assert logged["replayed"].episodes == soak.metrics.episodes == 4
    assert summarise(Trajectory(path).read()).episodes == 4
