import Base
import ./prelude.bend as P

# The cons case answers the empty list, so any nonempty list comes back empty
# and the singleton law fails.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.mod5_all_single`.
def mod5_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      Nil{}
