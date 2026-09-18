import Base
import ./prelude.bend as P

# The list comes back unchanged: the map is never applied. The singleton law
# asks for `P.cube(h) <> Nil{}` and `P.cube(h)` is stuck on a variable.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.cube_all_single`.
def cube_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      xs
