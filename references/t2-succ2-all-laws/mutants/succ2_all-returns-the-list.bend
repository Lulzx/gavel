import Base
import ./prelude.bend as P

# The list comes back unchanged: the map is never applied.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.succ2_all_single`.
def succ2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      xs
