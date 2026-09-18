import Base

# The zero case answered with the multiplier instead of zero: a plausible slip
# when the base case is copied from the step, where `b` is everywhere. Rejected
# by `mul_one_left` as a statement -- `mul(1n, x)` is `x + mul(0n, x)`, which is
# `x + x`, where the law wants `x` -- and by `mul_distrib`, whose left-hand side
# at `x = 0n` is `z + z` while its right-hand side is `z + mul(y, z)`. The
# checker stops in `L.mul_one_left`, whose step is written for a body whose
# answer contains the predecessor `p`.
def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      b + mul(p, b)
