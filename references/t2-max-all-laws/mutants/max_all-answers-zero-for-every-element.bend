import Base
import ./prelude.bend as P

# Every cell is answered with `0n`, which agrees with the reference only when
# the element and the ceiling are both zero. The singleton law fails at
# variables.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.max_all_single`.
def max_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +k = n
      0n <> max_all(t, k)
