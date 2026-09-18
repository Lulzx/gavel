import Base
import ./prelude.bend as P

# Every cell is answered with `1n`, which is `P.sq_inc` only for the input
# `0n`. The singleton law fails at a variable head.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.sq_inc_all_single`.
def sq_inc_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      1n <> sq_inc_all(t)
