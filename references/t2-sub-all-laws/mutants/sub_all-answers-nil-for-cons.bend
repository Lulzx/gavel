import Base
import ./prelude.bend as P

# The cons case answers the empty list, so any nonempty input comes back empty.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.sub_all_single`.
def sub_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      Nil{}
