import Base
import ./prelude.bend as P

# Adds the predecessor's sum to the predecessor itself, losing the `1n`: the
# arithmetic is one step short at every level. The base case is untouched, so
# `sum_to_zero` holds, and `sum_to_succ` is the pin that rejects it -- its right
# side is `S.sum_to(p) + (1n + p)` and this computes to `S.sum_to(p) + p`. The
# work law's helper `Policy.sum_to_double_add` fails against it as well.
def sum_to(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+p:
      +p = p
      sum_to(p) + p
