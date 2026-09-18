import Base
import ./prelude.bend as P

# The two arguments of `P.sub` are swapped, so each element has the step taken
# off it instead of taking the step off itself -- a saturating subtraction
# written the wrong way round. The singleton law asks for `P.sub(h, k)` and
# the body leaves `P.sub(k, h)`, and the two are different terms at
# variables.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.sub_all_single`.
def sub_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +k = n
      P.sub(k, h) <> sub_all(t, k)
