import Base
import ./prelude.bend as P

# Every cell is answered with `1n`, which is `P.pow2` only for the input `0n`.
# The singleton law fails at a variable head.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.pow2_all_single`.
def pow2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      1n <> pow2_all(t)
