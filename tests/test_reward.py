"""The reward function of SPEC.md 8."""

from __future__ import annotations

import pytest

from gavel.reward import (CHECKS_REWARD, COMPLETE_REWARD, assign_tier, compute,
                          dense_delta, partial_fraction, reward_for)
from gavel.verdict import (TIER_CHECKS, TIER_COMPLETE, TIER_NO_CHECK,
                           TIER_PARTIAL, TIER_REJECTED)


def test_the_tiers_are_ordered():
    assert (TIER_REJECTED, TIER_NO_CHECK, TIER_CHECKS, TIER_PARTIAL,
            TIER_COMPLETE) == (0, 1, 2, 3, 4)


@pytest.mark.parametrize("gate,solution,proven,n,want", [
    (False, False, 0, 2, TIER_REJECTED),   # the gate comes first, always
    (False, True, 2, 2, TIER_REJECTED),    # ...even with a perfect proof
    (True, False, 0, 2, TIER_NO_CHECK),
    (True, True, 0, 2, TIER_CHECKS),
    (True, True, 1, 2, TIER_PARTIAL),
    (True, True, 2, 2, TIER_COMPLETE),
    (True, True, 0, 0, TIER_CHECKS),       # a task with no laws
])
def test_assign_tier(gate, solution, proven, n, want):
    assert assign_tier(gate_ok=gate, solution_checks=solution,
                       proven=proven, n_laws=n) == want


def test_a_gate_rejection_is_worth_nothing():
    assert reward_for(TIER_REJECTED) == 0.0
    assert reward_for(TIER_NO_CHECK) == 0.0


def test_tier_two_is_non_zero_on_purpose():
    # A well-typed but unproven solution is progress; an all-or-nothing cliff
    # here is what makes the reward sparse for no reason.
    assert reward_for(TIER_CHECKS) == CHECKS_REWARD > 0.0


def test_partial_credit_is_monotone_in_the_laws_proven():
    rewards = [reward_for(TIER_PARTIAL, proven, 4) for proven in range(4)]
    assert rewards == sorted(rewards)
    assert len(set(rewards)) == 4


def test_partial_credit_never_reaches_completion():
    # Otherwise a policy could stop one law short and be paid the same.
    for n in range(1, 9):
        assert reward_for(TIER_PARTIAL, n - 1, n) < COMPLETE_REWARD


def test_partial_credit_never_falls_below_the_tier_two_reward():
    for n in range(1, 9):
        assert reward_for(TIER_PARTIAL, 1, n) >= CHECKS_REWARD


def test_completion_is_the_maximum():
    assert reward_for(TIER_COMPLETE, 4, 4) == COMPLETE_REWARD


def test_solving_half_the_laws_pays_half_the_partial_bonus():
    assert reward_for(TIER_PARTIAL, 2, 4) == pytest.approx(0.1 + 0.5 * 0.5)


def test_compute_agrees_with_its_parts():
    for gate in (True, False):
        for solution in (True, False):
            for proven in range(3):
                tier, reward = compute(gate_ok=gate, solution_checks=solution,
                                       proven=proven, n_laws=3)
                assert tier == assign_tier(gate_ok=gate, solution_checks=solution,
                                           proven=proven, n_laws=3)
                assert reward == reward_for(tier, proven, 3)


# --- multi-turn ---------------------------------------------------------------

def test_dense_reward_pays_improvement():
    assert dense_delta(0.0, 0.1) == pytest.approx(0.1)


def test_dense_reward_pays_nothing_for_standing_still():
    assert dense_delta(0.35, 0.35) == 0.0


def test_dense_reward_does_not_punish_regression():
    # SPEC.md 8 note 3: a turn that makes things worse costs the policy the
    # progress it already had. Rewarding repair and not punishing regression
    # is what keeps a struggling policy exploring instead of stalling.
    assert dense_delta(0.6, 0.1) == 0.0


def test_dense_reward_is_measured_against_the_best_not_the_last():
    best = 0.6
    assert dense_delta(best, 0.1) == 0.0     # a bad turn
    assert dense_delta(best, 0.8) == pytest.approx(0.2)  # then a better one
    assert dense_delta(best, 1.0) == pytest.approx(0.4)


def test_partial_fraction():
    assert partial_fraction(TIER_COMPLETE, 3, 3) == 1.0
    assert partial_fraction(TIER_PARTIAL, 1, 4) == 0.25
    assert partial_fraction(TIER_CHECKS, 0, 4) == 0.0
    assert partial_fraction(TIER_CHECKS, 0, 0) == 0.0
