import Base
import ./prelude.bend as P

# TODO(policy): the difference between `a` and `b`. Nat has no negative numbers,
# so it is the sum of the two truncated subtractions. Both parameters are used
# in both subtractions, so both are declared `+`.
def absdiff(+a: Nat, +b: Nat) -> Nat:
  ?TODO
