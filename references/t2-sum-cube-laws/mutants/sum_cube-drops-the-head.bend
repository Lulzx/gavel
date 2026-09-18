import Base
import ./prelude.bend as P

# The step ignores the head and recurses on the tail, so the answer is the
# sum of nothing at all. The nil law still holds.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_cube_nil'], first
# failure at `LAWS.sum_cube_snoc`.
def sum_cube(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      sum_cube(t)
