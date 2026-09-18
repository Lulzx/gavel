import Base
import ./prelude.bend as P

# The step answers the transformed head and never recurses, so only the
# first element counts. The nil law holds; the snoc law fails.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_cube_nil'], first
# failure at `LAWS.sum_cube_snoc`.
def sum_cube(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.cube(h)
