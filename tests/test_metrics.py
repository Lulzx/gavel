"""The run report. No checker.

Two things are worth more than the counter arithmetic. A report built from a log
must equal the report built live -- otherwise a finished soak and a watched soak
disagree. And the latency percentiles must exclude cache hits, or a warm cache
reports a fast machine.
"""

from __future__ import annotations

import json

import pytest

from gavel.metrics import Metrics, percentile, summarise
from gavel.trajectory import EpisodeRecord, Trajectory, TurnRecord
from gavel.verdict import (TIER_CHECKS, TIER_COMPLETE, TIER_NO_CHECK,
                           TIER_REJECTED, CheckResult, GateFinding, GateResult,
                           Verdict)


def turn(tier: int, ms: int = 10, *, cached: bool = False, reward=None,
         checks: int = 1, gate_ok: bool = True, incident: str | None = None):
    results = tuple(CheckResult(ok=tier == TIER_COMPLETE, exit_code=0, ms=ms)
                    for _ in range(checks))
    gate = GateResult(ok=gate_ok,
                      findings=() if gate_ok else (GateFinding("unsafe", "nope"),))
    verdict = Verdict(task_id="t-fake", tier=tier,
                      reward=(0.0 if reward is None else reward),
                      n_laws=2, proven=(), failed=(), gate=gate, checks=results,
                      cached=cached, incident=incident)
    return TurnRecord(turn=1, reward=verdict.reward, done=True, verdict=verdict)


def episode(number: int = 0, tier: int = TIER_COMPLETE, **over) -> EpisodeRecord:
    turns = over.pop("turns", [turn(tier)])
    fields = dict(episode=number, task_id="t-fake", tier=1, mode="dense",
                  turns=turns)
    fields.update(over)
    return EpisodeRecord(**fields)


# --- percentile -------------------------------------------------------------------

def test_the_median_of_an_odd_sample_is_the_middle_element():
    assert percentile([5, 1, 3], 50) == 3


def test_the_median_of_an_even_sample_takes_the_lower_of_the_two():
    """Nearest-rank: it must return a value some check actually took."""
    assert percentile([1, 2, 3, 4], 50) == 2


def test_the_tail_is_the_tail():
    sample = list(range(1, 101))
    assert percentile(sample, 95) == 95
    assert percentile(sample, 99) == 99
    assert percentile(sample, 100) == 100


def test_a_single_sample_is_its_own_every_percentile():
    assert percentile([7], 99) == 7


def test_a_percentile_of_nothing_is_an_error_not_zero():
    """Zero would read as "instant", which is the opposite of "we did not
    measure"."""
    with pytest.raises(ValueError):
        percentile([], 50)


# --- counters ---------------------------------------------------------------------

def test_an_empty_report_is_all_zeroes():
    report = Metrics().to_json()
    assert report["episodes"] == 0
    assert report["solve_rate"] == 0.0
    assert report["latency_ms"] == {}


def test_solve_rate_and_mean_reward():
    metrics = Metrics()
    metrics.add(episode(0, TIER_COMPLETE, turns=[turn(4, reward=1.0)]))
    metrics.add(episode(1, TIER_CHECKS, turns=[turn(2, reward=0.0)]))
    assert metrics.episodes == 2
    assert metrics.solve_rate == 0.5
    assert metrics.mean_reward == 0.5
    assert metrics.mean_turns == 1.0


def test_the_tier_histogram_counts_where_episodes_ended():
    metrics = Metrics()
    metrics.add(episode(0, TIER_COMPLETE))
    metrics.add(episode(1, TIER_COMPLETE))
    metrics.add(episode(2, TIER_CHECKS))
    assert metrics.to_json()["by_tier"] == {"2": 1, "4": 2}


def test_the_turn_histogram_counts_every_turn_not_every_episode():
    """The histogram that shows a curriculum is being climbed: an episode that
    reached tier 4 via tier 2 contributes to both."""
    metrics = Metrics()
    metrics.add(episode(0, TIER_COMPLETE, turns=[
        TurnRecord(turn=1, reward=0.1, done=False, verdict=Verdict(
            task_id="t-fake", tier=TIER_CHECKS, reward=0.1, n_laws=2)),
        turn(TIER_COMPLETE, reward=0.9),
    ]))
    assert metrics.to_json()["turn_tiers"] == {"2": 1, "4": 1}


def test_gate_rejections_are_counted_separately_from_checks():
    metrics = Metrics()
    metrics.add(episode(0, TIER_REJECTED, turns=[
        turn(TIER_REJECTED, reward=0.0, checks=0, gate_ok=False)]))
    report = metrics.to_json()
    assert report["gate_rejections"] == 1
    assert report["fresh_checks"] == 0


def test_an_incident_is_surfaced_because_it_should_never_happen():
    """A nonzero count means V2 let a task through, so the report must not
    bury it in a tier histogram."""
    metrics = Metrics()
    metrics.add(episode(0, TIER_COMPLETE,
                        turns=[turn(TIER_COMPLETE, reward=0.0,
                                    incident="reproduced add-constant-body")]))
    assert metrics.to_json()["incidents"] == 1


# --- latency ----------------------------------------------------------------------

def test_latency_is_measured_over_fresh_checks_only():
    metrics = Metrics()
    metrics.add(episode(0, turns=[turn(TIER_CHECKS, ms=500)]))
    metrics.add(episode(1, turns=[turn(TIER_CHECKS, ms=700, cached=True)]))
    report = metrics.to_json()
    assert report["fresh_checks"] == 1
    assert report["cache_hits"] == 1
    assert report["latency_ms"] == {"p50": 500.0, "p90": 500.0,
                                    "p95": 500.0, "p99": 500.0}


def test_a_gate_rejection_contributes_no_latency():
    """It never ran the checker, so it has no time to report."""
    metrics = Metrics()
    metrics.add(episode(0, TIER_REJECTED,
                        turns=[turn(TIER_REJECTED, checks=0, gate_ok=False)]))
    assert metrics.to_json()["latency_ms"] == {}


def test_the_percentiles_of_a_bimodal_run_are_not_the_mean():
    """The checker is bimodal -- a parse error is fast, a fixed point is not --
    which is why the report carries percentiles at all."""
    metrics = Metrics()
    for i in range(99):
        metrics.add(episode(i, turns=[turn(TIER_NO_CHECK, ms=5, reward=0.0)]))
    metrics.add(episode(99, turns=[turn(TIER_COMPLETE, ms=9000, reward=1.0)]))
    latencies = metrics.to_json()["latency_ms"]
    assert latencies["p50"] == 5.0
    assert latencies["p99"] == 5.0
    assert metrics.fresh_ms and max(metrics.fresh_ms) == 9000


# --- the report agrees with the log ------------------------------------------------

def test_a_report_from_the_log_equals_the_report_built_live(tmp_path):
    """Otherwise a finished soak and a watched one disagree, and there is no
    way to tell which is wrong."""
    path = tmp_path / "trajectory.jsonl"
    live = Metrics()
    with Trajectory(path) as log:
        for i, tier in enumerate([TIER_COMPLETE, TIER_CHECKS, TIER_COMPLETE]):
            record = episode(i, tier)
            live.add(record)
            log.write(record)
    assert summarise(Trajectory(path).read()).to_json() == live.to_json()


def test_the_report_is_json_serialisable(tmp_path):
    metrics = Metrics()
    metrics.add(episode(0))
    path = tmp_path / "metrics.json"
    metrics.write(path)
    blob = json.loads(path.read_text())
    assert blob["episodes"] == 1
    assert blob["solve_rate"] == 1.0
