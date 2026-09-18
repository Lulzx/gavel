import Base
import ./prelude.bend as P

# The list comes back unchanged, so the subtraction never happens.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.sub_all_single`.
def sub_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      xs
