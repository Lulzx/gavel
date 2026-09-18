"""The reward function of SPEC.md 8, as a pure function.

No I/O, no clock, no model. Everything the reward depends on arrives as
arguments, which is what makes it property-testable and what makes historical
trajectories reproducible after the harness changes.
"""

from __future__ import annotations

from .verdict import (TIER_CHECKS, TIER_COMPLETE, TIER_NO_CHECK, TIER_PARTIAL,
                      TIER_REJECTED)

# SPEC.md 8. A tier-3 submission earns a base plus a share of the remainder.
CHECKS_REWARD = 0.1
PARTIAL_BASE = 0.1
PARTIAL_SCALE = 0.5
COMPLETE_REWARD = 1.0


def assign_tier(*, gate_ok: bool, solution_checks: bool,
                proven: int, n_laws: int) -> int:
    """The tier a submission lands in."""
    if not gate_ok:
        return TIER_REJECTED
    if not solution_checks:
        return TIER_NO_CHECK
    if n_laws <= 0:
        return TIER_CHECKS
    if proven >= n_laws:
        return TIER_COMPLETE
    if proven > 0:
        return TIER_PARTIAL
    return TIER_CHECKS


def reward_for(tier: int, proven: int = 0, n_laws: int = 0) -> float:
    """The scalar reward for a tier (SPEC.md 8)."""
    if tier <= TIER_NO_CHECK:
        return 0.0
    if tier == TIER_CHECKS:
        return CHECKS_REWARD
    if tier == TIER_PARTIAL:
        if n_laws <= 0:
            return CHECKS_REWARD
        return PARTIAL_BASE + PARTIAL_SCALE * (proven / n_laws)
    return COMPLETE_REWARD


def compute(*, gate_ok: bool, solution_checks: bool,
            proven: int, n_laws: int) -> tuple[int, float]:
    tier = assign_tier(gate_ok=gate_ok, solution_checks=solution_checks,
                       proven=proven, n_laws=n_laws)
    return tier, reward_for(tier, proven, n_laws)


def dense_delta(previous_best: float, current: float) -> float:
    """Multi-turn dense reward: the improvement over the best turn so far.

    Repair is rewarded and regression is not (SPEC.md 8, note 3), which is why
    this is a difference against the best result, not against the last one.
    """
    return max(0.0, current - previous_best)


def partial_fraction(tier: int, proven: int, n_laws: int) -> float:
    """The share of laws proven, for logging and curriculum bookkeeping."""
    if n_laws <= 0:
        return 0.0
    if tier == TIER_COMPLETE:
        return 1.0
    return proven / n_laws
