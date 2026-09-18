"""The episode protocol. Fast tests first, then the ones that drive the checker."""

from __future__ import annotations

import pytest

from gavel.env import Action, EnvError, GavelEnv, tier_sampler
from gavel.tasks import PROOF_FILE, SOLUTION_FILE
from gavel.verdict import TIER_COMPLETE

pytestmark = pytest.mark.checker

TASK = "t1-add-zero"


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
        PROOF_FILE: task.proof_header + "\ndef L.add_zero(x):\n  ?TODO\n"}))
    feedback = observation["feedback"]
    assert "TODO" in feedback or "Error" in feedback
    assert observation["turn"] == 2


def test_feedback_carries_gate_findings_without_running_the_checker(env, task):
    env.reset(TASK)
    observation, reward, _, verdict = env.step(Action(files={
        SOLUTION_FILE: task.reference_solution,
        PROOF_FILE: task.proof_header + "\n@unsafe\ndef L.add_zero(x):\n  {==}\n"}))
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
