import Base
import ./prelude.bend as P

# The list comes back unchanged: nothing is duplicated. The singleton law asks
# for `h <> (h <> Nil{})` and gets `h <> Nil{}`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.dup_all_single`.
def dup_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      xs
