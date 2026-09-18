import Base
import ./prelude.bend as P

# The step answers the head's indicator and never recurses, so the count comes
# from the first element alone. The nil law holds and the snoc law fails.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_nonzero_nil'], first
# failure at `LAWS.sum_nonzero_snoc`.
def sum_nonzero(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.is_nonzero(h)
