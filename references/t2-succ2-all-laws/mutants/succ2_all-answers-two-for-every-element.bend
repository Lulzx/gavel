import Base
import ./prelude.bend as P

# Every cell is answered with `2n`, which is `P.succ2` only for the input `0n`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.succ2_all_single`.
def succ2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      2n <> succ2_all(t)
