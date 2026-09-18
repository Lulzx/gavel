"""The episode log. No checker: records are built by hand.

The property worth pinning is that a log survives its own process. A soak that
dies mid-write should leave every episode before the last one readable, and the
last one should be skipped rather than poisoning the file.
"""

from __future__ import annotations

import json

from gavel.trajectory import EpisodeRecord, Trajectory, TurnRecord, replay
from gavel.verdict import TIER_CHECKS, TIER_COMPLETE, TIER_PARTIAL, Verdict


def verdict(tier: int, reward: float = 0.0, cached: bool = False) -> Verdict:
    return Verdict(task_id="t-fake", tier=tier, reward=reward, n_laws=2,
                   proven=(), failed=(), ms=12, cached=cached)


def episode(number: int = 0, **over) -> EpisodeRecord:
    turns = over.pop("turns", [
        TurnRecord(turn=1, reward=0.1, done=False, verdict=verdict(TIER_CHECKS)),
        TurnRecord(turn=2, reward=0.9, done=True,
                   verdict=verdict(TIER_COMPLETE, 1.0)),
    ])
    fields = dict(episode=number, task_id="t-fake", tier=1, mode="dense",
                  seed=7, ms=250, turns=turns)
    fields.update(over)
    return EpisodeRecord(**fields)


# --- one record -------------------------------------------------------------------

def test_an_episode_knows_what_it_earned():
    assert episode().total_reward == 1.0
    assert episode().turns_used == 2
    assert episode().solved


def test_solved_is_any_turn_not_the_last_turn():
    """A policy that solves on turn 2 and keeps submitting has solved it."""
    record = episode(turns=[
        TurnRecord(turn=1, reward=1.0, done=True,
                   verdict=verdict(TIER_COMPLETE, 1.0)),
        TurnRecord(turn=2, reward=0.0, done=False, verdict=verdict(TIER_CHECKS)),
    ])
    assert record.solved
    assert record.best_tier == TIER_COMPLETE


def test_an_episode_that_never_solved_says_so():
    record = episode(turns=[TurnRecord(turn=1, reward=0.0, done=True,
                                       verdict=verdict(TIER_PARTIAL))])
    assert not record.solved
    assert record.best_tier == TIER_PARTIAL


def test_an_empty_episode_is_not_solved():
    record = EpisodeRecord(episode=0, task_id="t-fake", tier=1, mode="dense")
    assert not record.solved
    assert record.best_tier == 0
    assert record.total_reward == 0.0


def test_the_record_counts_its_own_cache_hits():
    record = episode(turns=[
        TurnRecord(turn=1, reward=0.0, done=False,
                   verdict=verdict(TIER_CHECKS, cached=True)),
        TurnRecord(turn=2, reward=1.0, done=True,
                   verdict=verdict(TIER_COMPLETE, 1.0)),
    ])
    assert record.cache_hits == 1


# --- the file ---------------------------------------------------------------------

def test_a_record_survives_the_file(tmp_path):
    path = tmp_path / "trajectory.jsonl"
    with Trajectory(path) as log:
        log.write(episode(0))
    (back,) = replay(path)
    assert back.turns_used == 2
    assert back.total_reward == 1.0
    assert back.solved
    # The whole verdict comes back, not a summary of it.
    assert back.turns[1].verdict.tier == TIER_COMPLETE


def test_one_line_per_episode(tmp_path):
    path = tmp_path / "trajectory.jsonl"
    with Trajectory(path) as log:
        for i in range(3):
            log.write(episode(i))
    lines = path.read_text().strip().splitlines()
    assert len(lines) == 3
    assert [json.loads(line)["episode"] for line in lines] == [0, 1, 2]


def test_a_second_open_appends_rather_than_truncates(tmp_path):
    """A soak that restarts must not erase the run before it."""
    path = tmp_path / "trajectory.jsonl"
    with Trajectory(path) as log:
        log.write(episode(0))
    with Trajectory(path) as log:
        log.write(episode(1))
    assert [e.episode for e in replay(path)] == [0, 1]


def test_a_half_written_last_line_is_skipped(tmp_path):
    """The reason for JSONL: a killed process should leave a readable log."""
    path = tmp_path / "trajectory.jsonl"
    with Trajectory(path) as log:
        log.write(episode(0))
    with path.open("a") as handle:
        handle.write('{"episode": 1, "task_id": "t-fake", "tier"')
    assert [e.episode for e in replay(path)] == [0]


def test_reading_a_log_that_was_never_written_is_empty(tmp_path):
    assert replay(tmp_path / "nothing.jsonl") == []


def test_writing_creates_the_directory(tmp_path):
    path = tmp_path / "runs" / "soak" / "trajectory.jsonl"
    with Trajectory(path) as log:
        log.write(episode(0))
    assert log.episodes_written == 1
    assert path.exists()


# --- the actions ------------------------------------------------------------------

def test_a_turn_with_no_actions_omits_the_key_rather_than_writing_null():
    """The largest field, and the one most likely to hold something a policy
    would rather not have logged: an absent key, not a null one.

    ``TurnRecord`` keeps whatever it is given; it is ``GavelEnv.store_actions``
    that decides whether it is given anything (see tests/test_env.py).
    """
    quiet = TurnRecord(turn=1, reward=0.0, done=True, verdict=verdict(TIER_CHECKS))
    assert "files" not in quiet.to_json()
    assert TurnRecord.from_json(quiet.to_json()).files is None


def test_an_action_is_recoverable_when_it_is_kept(tmp_path):
    path = tmp_path / "trajectory.jsonl"
    record = episode(turns=[TurnRecord(
        turn=1, reward=0.0, done=True, verdict=verdict(TIER_CHECKS),
        files={"solution.bend": "import Base\n", "PROOF.bend": "import Base\n"})])
    with Trajectory(path) as log:
        log.write(record)
    (back,) = replay(path)
    assert back.turns[0].files == {"solution.bend": "import Base\n",
                                   "PROOF.bend": "import Base\n"}


def test_the_record_round_trips_through_json_unchanged():
    record = episode()
    assert EpisodeRecord.from_json(record.to_json()).to_json() == record.to_json()


# --- which bank, which checker -----------------------------------------------------

def test_the_log_names_the_bank_and_the_checker(tmp_path):
    """A reward is only meaningful against a named bank checked by a named
    toolchain, and neither is recoverable from the log afterwards."""
    path = tmp_path / "trajectory.jsonl"
    record = episode(run_id="r1", bank_hash="bank-sha", bend_version="2.0.5")
    with Trajectory(path) as log:
        log.write(record)
    (back,) = replay(path)
    assert back.bank_hash == "bank-sha"
    assert back.bend_version == "2.0.5"
    assert back.episode_id == "r1:0"


def test_a_run_id_is_stamped_when_the_writer_has_one(tmp_path):
    path = tmp_path / "trajectory.jsonl"
    with Trajectory(path, run_id="run-7") as log:
        log.write(episode(0))
    (back,) = replay(path)
    assert back.run_id == "run-7"
    assert back.episode_id == "run-7:0"


def test_two_runs_get_different_ids():
    """Otherwise two sweeps against one bank are indistinguishable in a log
    directory."""
    assert Trajectory("a.jsonl").run_id != Trajectory("b.jsonl").run_id


def test_the_run_id_sorts_by_time():
    """The prefix is UTC, so a directory of logs lists chronologically."""
    run_id = Trajectory("a.jsonl").run_id
    assert run_id[:9].endswith("T") and run_id[:8].isdigit()
    assert len(run_id) == 16 + 1 + 8
