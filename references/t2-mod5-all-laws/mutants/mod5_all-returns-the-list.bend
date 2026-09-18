import Base
import ./prelude.bend as P

# The list comes back unchanged, so nothing is reduced. The singleton law asks
# for `P.mod5(h) <> Nil{}` and `P.mod5(h)` is stuck on a variable `h`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.mod5_all_single`.
def mod5_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      xs
