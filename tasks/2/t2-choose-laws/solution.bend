import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on the first argument, then on the second:
# nothing left to choose from answers `1n` for a count of `0n` and `0n` for
# every larger count, a count of `0n` answers `1n`, and a pair of successors
# answers the selections that leave the first item out plus the selections that
# take it. The count is read twice in the step -- once as itself and once as its
# predecessor -- so it is marked reusable, and its predecessor is written as
# `Nat.sub(k, 1n)` because the pattern that bound it cannot be named again.
def choose(n: Nat, +k: Nat) -> Nat:
  ?TODO
