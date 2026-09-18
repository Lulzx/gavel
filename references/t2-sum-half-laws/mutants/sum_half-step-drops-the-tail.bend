import Base
import ./prelude.bend as P

# The step answers the head's half and never recurses, so only the first
# element counts. The nil law holds and the snoc law fails.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_half_nil'], first
# failure at `LAWS.sum_half_snoc`.
def sum_half(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.half(h)
