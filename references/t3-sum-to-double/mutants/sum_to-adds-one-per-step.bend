import Base
import ./prelude.bend as P

# Each step adds `1n` instead of the value it is stepping over, so the answer is
# the index rather than the triangle. The zero law holds, `sum_to_succ` fails at
# a variable `p` (the law names the term `1n + p`), and `sum_to_double` fails
# with it. p is used once here, so no rebind is needed. Measured:
# `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.sum_to_double_add`.
def sum_to(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+p:
      sum_to(p) + 1n
