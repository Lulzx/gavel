import Base
import ./prelude.bend as P

# A nonempty list is answered with the empty list, so the duplication never
# happens. The singleton law refuses it.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.dup_all_single`.
def dup_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      Nil{}
