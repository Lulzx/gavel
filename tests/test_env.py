"""The episode protocol. Fast tests first, then the ones that drive the checker."""

from __future__ import annotations

import pytest

from gavel.check import CheckConfig
from gavel.env import Action, EnvError, GavelEnv, tier_sampler
from gavel.tasks import PROOF_FILE, SOLUTION_FILE
from gavel.trajectory import Trajectory
from gavel.verdict import TIER_COMPLETE

pytestmark = pytest.mark.checker

TASK = "t1-add-plus"


@pytest.fixture
def env(manifest, toolchain):
    made = GavelEnv(manifest=manifest, toolchain=toolchain, seed=0)
    yield made
    made.close()


def reference_action(task) -> Action:
    return Action(files={SOLUTION_FILE: task.reference_solution,
                         PROOF_FILE: task.reference_proof})


# --- characterisation, no checker ----------------------------------------------

def test_an_action_may_only_contain_submittable_files():
    with pytest.raises(EnvError, match="may contain only"):
        Action(files={"LAWS.bend": "law x:\n  for a: Nat\n  {a == a : Nat}\n"})


def test_an_unknown_mode_is_refused(manifest, toolchain):
    with pytest.raises(EnvError, match="mode must be"):
        GavelEnv(manifest=manifest, toolchain=toolchain, mode="fast")


def test_max_turns_must_be_positive(manifest, toolchain):
    with pytest.raises(EnvError, match="at least 1"):
        GavelEnv(manifest=manifest, toolchain=toolchain, max_turns=0)


# --- episodes ------------------------------------------------------------------

def test_reset_returns_the_task_and_the_first_turn(env):
    observation = env.reset(TASK)
    assert observation["task_id"] == TASK
    assert observation["turn"] == 1
    assert observation["max_turns"] == 4
    assert observation["feedback"] is None
    assert observation["laws"].strip()
    assert observation["stub"].strip()
    assert observation["proof_header"]


def test_a_reference_submission_solves_the_episode_in_one_turn(env, task):
    env.reset(TASK)
    observation, reward, done, verdict = env.step(reference_action(task))
    assert done
    assert verdict.tier == TIER_COMPLETE
    assert reward == pytest.approx(1.0)
    assert observation["feedback"] is None     # nothing left to repair


def test_dense_reward_pays_only_for_improvement(env, task):
    env.reset(TASK)
    # A well-typed but unproven solution: tier 2, which is the first thing
    # worth paying for.
    _, first, done, _ = env.step(Action(files={
        SOLUTION_FILE: task.reference_solution,
        PROOF_FILE: task.proof_header}))
    assert not done
    assert first == pytest.approx(0.1)
    # The same submission again cannot be paid twice.
    _, second, _, _ = env.step(Action(files={
        SOLUTION_FILE: task.reference_solution,
        PROOF_FILE: task.proof_header}))
    assert second == 0.0


def test_dense_reward_pays_the_improvement_to_completion(env, task):
    env.reset(TASK)
    env.step(Action(files={SOLUTION_FILE: task.reference_solution,
                           PROOF_FILE: task.proof_header}))
    _, reward, done, verdict = env.step(reference_action(task))
    assert done
    assert verdict.tier == TIER_COMPLETE
    assert reward == pytest.approx(0.9)        # 1.0 - the 0.1 already paid


def test_a_regression_earns_nothing_and_loses_nothing(env, task):
    env.reset(TASK)
    env.step(reference_action(task))           # solve it, bank 1.0
    env.close()
    env.reset(TASK)
    env.step(Action(files={SOLUTION_FILE: task.reference_solution,
                           PROOF_FILE: task.proof_header}))
    _, reward, _, _ = env.step(Action(files={SOLUTION_FILE: "import Base\n",
                                             PROOF_FILE: task.proof_header}))
    assert reward == 0.0                       # best-so-far is untouched


def test_the_episode_ends_when_turns_run_out(env, task):
    env.reset(TASK)
    stub = Action(files={SOLUTION_FILE: task.stub_src,
                         PROOF_FILE: task.proof_header})
    for _ in range(env.max_turns - 1):
        _, _, done, _ = env.step(stub)
        assert not done
    _, _, done, verdict = env.step(stub)
    assert done
    assert verdict.tier != TIER_COMPLETE


def test_stepping_past_the_end_is_an_error_not_a_silent_extra_turn(env, task):
    env.reset(TASK)
    stub = Action(files={SOLUTION_FILE: task.stub_src,
                         PROOF_FILE: task.proof_header})
    for _ in range(env.max_turns):
        env.step(stub)
    with pytest.raises(EnvError, match="episode .* is over"):
        env.step(stub)


def test_stepping_before_reset_is_an_error(env):
    with pytest.raises(EnvError, match="before reset"):
        env.step(Action(files={SOLUTION_FILE: "", PROOF_FILE: ""}))


def test_feedback_carries_the_checkers_own_words(env, task):
    env.reset(TASK)
    observation, _, _, _ = env.step(Action(files={
        SOLUTION_FILE: task.reference_solution,
        PROOF_FILE: task.proof_header + "\ndef L.add_plus(x, y):\n  ?TODO\n"}))
    feedback = observation["feedback"]
    assert "TODO" in feedback or "Error" in feedback
    assert observation["turn"] == 2


def test_feedback_carries_gate_findings_without_running_the_checker(env, task):
    env.reset(TASK)
    observation, reward, _, verdict = env.step(Action(files={
        SOLUTION_FILE: task.reference_solution,
        PROOF_FILE: task.proof_header + "\n@unsafe\ndef L.add_plus(x, y):\n  {==}\n"}))
    assert reward == 0.0
    assert verdict.checks == ()
    assert "unsafe" in observation["feedback"].lower()


def test_sparse_mode_pays_nothing_until_the_episode_is_solved(manifest, toolchain, task):
    env = GavelEnv(manifest=manifest, toolchain=toolchain, mode="sparse", seed=0)
    try:
        env.reset(TASK)
        _, first, done, _ = env.step(Action(files={
            SOLUTION_FILE: task.reference_solution,
            PROOF_FILE: task.proof_header}))
        assert not done
        assert first == 0.0
        _, second, done, _ = env.step(reference_action(task))
        assert done
        assert second == pytest.approx(1.0)
    finally:
        env.close()


# --- sampling -------------------------------------------------------------------

def test_reset_without_a_task_id_samples(manifest, toolchain):
    env = GavelEnv(manifest=manifest, toolchain=toolchain, seed=0)
    try:
        seen = {env.reset()["task_id"] for _ in range(20)}
        assert seen
        assert seen <= {t.task_id for t in manifest}
    finally:
        env.close()


def test_a_tier_sampler_stays_within_its_tiers(manifest, toolchain):
    env = GavelEnv(manifest=manifest, toolchain=toolchain, seed=0,
                   sampler=tier_sampler((1,)))
    try:
        for _ in range(20):
            assert env.reset()["tier"] == 1
    finally:
        env.close()


def test_an_unknown_task_id_is_refused(env):
    with pytest.raises(Exception, match="no task"):
        env.reset("no-such-task")


# --- logging and metrics ---------------------------------------------------------

def test_a_solved_episode_is_logged_once(tmp_path, manifest, toolchain, task):
    from gavel.trajectory import replay

    path = tmp_path / "trajectory.jsonl"
    env = GavelEnv(manifest=manifest, toolchain=toolchain, seed=0,
                   trajectory=Trajectory(path))
    try:
        env.reset(TASK)
        env.step(reference_action(task))
    finally:
        env.close()

    (record,) = replay(path)
    assert record.task_id == TASK
    assert record.solved
    assert record.tier == 1
    assert record.turns_used == 1
    assert record.total_reward == pytest.approx(1.0)
    # The episode says which bank and which checker produced its reward.
    assert record.bank_hash == manifest.hash
    assert record.bend_version == toolchain.version
    assert record.run_id == env.trajectory.run_id


def test_a_finished_episode_is_not_logged_twice_by_close(tmp_path, manifest,
                                                        toolchain, task):
    from gavel.trajectory import replay

    path = tmp_path / "trajectory.jsonl"
    env = GavelEnv(manifest=manifest, toolchain=toolchain, seed=0,
                   trajectory=Trajectory(path))
    env.reset(TASK)
    env.step(reference_action(task))     # done
    env.close()                          # must not write it again
    assert len(replay(path)) == 1


def test_an_abandoned_episode_is_still_logged(tmp_path, manifest, toolchain, task):
    """A policy that resets mid-episode: the turns it did spend are data."""
    from gavel.trajectory import replay

    path = tmp_path / "trajectory.jsonl"
    env = GavelEnv(manifest=manifest, toolchain=toolchain, seed=0,
                   trajectory=Trajectory(path))
    try:
        env.reset(TASK)
        env.step(Action(files={SOLUTION_FILE: task.reference_solution,
                               PROOF_FILE: task.proof_header}))
        env.reset(TASK)                  # abandons the first episode
    finally:
        env.close()

    abandoned, second = replay(path)
    assert abandoned.turns_used == 1
    assert not abandoned.solved
    assert abandoned.best_tier == 2
    assert second.turns_used == 0        # the second was never stepped


def test_the_metrics_agree_with_the_log(tmp_path, manifest, toolchain, task):
    from gavel.metrics import summarise
    from gavel.trajectory import Trajectory as Log

    path = tmp_path / "trajectory.jsonl"
    env = GavelEnv(manifest=manifest, toolchain=toolchain, seed=0,
                   trajectory=Log(path))
    try:
        for _ in range(2):
            env.reset(TASK)
            env.step(reference_action(task))
    finally:
        env.close()

    assert env.metrics.episodes == 2
    assert sum(env.metrics.by_tier.values()) == 2
    assert env.metrics.by_tier[TIER_COMPLETE] == 2
    assert summarise(Log(path).read()).to_json() == env.metrics.to_json()


def test_the_actions_are_logged_only_when_asked(tmp_path, manifest, toolchain, task):
    from gavel.trajectory import replay

    quiet = tmp_path / "quiet.jsonl"
    loud = tmp_path / "loud.jsonl"
    for path, store in ((quiet, False), (loud, True)):
        env = GavelEnv(manifest=manifest, toolchain=toolchain, seed=0,
                       trajectory=Trajectory(path), store_actions=store)
        try:
            env.reset(TASK)
            env.step(reference_action(task))
        finally:
            env.close()

    assert replay(quiet)[0].turns[0].files is None
    assert replay(loud)[0].turns[0].files[SOLUTION_FILE] == task.reference_solution


def test_an_env_with_a_cache_serves_the_second_episode_from_it(tmp_path, manifest,
                                                               toolchain, task):
    """The point of the cache: a repeated submission costs no checker run, and
    the verdict it hands back says it was reused."""
    from gavel.cache import VerdictCache

    cache = VerdictCache(tmp_path / "cache.sqlite")
    env = GavelEnv(manifest=manifest, toolchain=toolchain, seed=0, cache=cache,
                   config=CheckConfig(backend="plain"))
    try:
        for expected_cached in (False, True):
            env.reset(TASK)
            _, reward, done, verdict = env.step(reference_action(task))
            assert done and reward == pytest.approx(1.0)
            assert verdict.tier == TIER_COMPLETE
            assert verdict.cached is expected_cached
    finally:
        env.close()
    assert cache.stats.hits == 1
    assert env.metrics.cache_hits == 1


def test_the_cache_outlives_the_env_that_used_it(tmp_path, manifest, toolchain,
                                                 task):
    """close() must not close a memo that several envs are sharing."""
    from gavel.cache import VerdictCache

    cache = VerdictCache(tmp_path / "cache.sqlite")
    for _ in range(2):
        env = GavelEnv(manifest=manifest, toolchain=toolchain, seed=0, cache=cache,
                       config=CheckConfig(backend="plain"))
        env.reset(TASK)
        env.step(reference_action(task))
        env.close()
    assert cache.rows() == 1
