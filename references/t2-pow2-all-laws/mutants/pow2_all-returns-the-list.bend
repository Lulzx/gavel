import Base
import ./prelude.bend as P

# The list comes back unchanged, so nothing is mapped. The singleton law asks
# for `P.pow2(h) <> Nil{}` and `P.pow2(h)` is stuck on a variable `h`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.pow2_all_single`.
def pow2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      xs
