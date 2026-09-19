import Base
import ./prelude.bend as P

# TODO(policy): implement. Euclid's algorithm with the remaining steps handed in
# as the first argument: `0n` of budget answers the best divisor found so far,
# a divisor of `0n` answers `a`, and otherwise one more budget buys the step that
# replaces `a` with `b` and `b` with the remainder of `a` by `b`. The divisor is
# read twice in the step -- once as itself and once inside the remainder -- so
# the parameter is marked reusable.
def gcd(fuel: Nat, a: Nat, +b: Nat) -> Nat:
  ?TODO
