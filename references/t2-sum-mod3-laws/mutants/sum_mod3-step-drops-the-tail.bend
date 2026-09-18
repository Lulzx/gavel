import Base
import ./prelude.bend as P

# The step answers the reduced head and never recurses, so only the first
# element counts. The nil law holds and the snoc law fails.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_mod3_nil'], first
# failure at `LAWS.sum_mod3_snoc`.
def sum_mod3(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.mod3(h)
