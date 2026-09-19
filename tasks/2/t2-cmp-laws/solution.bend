import Base
import ./prelude.bend as P

# TODO(policy): implement. `cmp(a, b)` answers `Lt{}` when `a` is below `b`,
# `Eq{}` when they are the same number and `Gt{}` when `a` is above `b`. Match
# on `a` and then on `b`: two zeroes are equal, a zero against a successor is
# below, a successor against a zero is above, and two successors are the answer
# for what is below them.
def cmp(a: Nat, b: Nat) -> P.Tri:
  ?TODO
