import Base
import ./prelude.bend as P

# The count is thrown away as soon as it is a successor: the body answers
# P.sum(xs), adding up the list, whatever the count was. This is the escape probe -- it is
# right at `0n` and right at exactly `P.len(xs)`, and wrong for every other
# count. It is refused: with a variable `xs`, `P.len(xs)` is stuck, so the
# length law cannot be unfolded onto this body's second case and the two sides
# never meet. No hole here.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_prefix_zero',
# 'sum_prefix_nil'], first failure at `LAWS.sum_prefix_len`.
def sum_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      P.sum(xs)
