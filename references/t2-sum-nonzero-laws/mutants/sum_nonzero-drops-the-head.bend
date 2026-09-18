import Base
import ./prelude.bend as P

# The step ignores the head and recurses on the tail, so every list counts zero
# nonzero elements. The nil law still holds.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_nonzero_nil'], first
# failure at `LAWS.sum_nonzero_snoc`.
def sum_nonzero(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      sum_nonzero(t)
