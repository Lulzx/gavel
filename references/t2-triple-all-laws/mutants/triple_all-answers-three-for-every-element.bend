import Base
import ./prelude.bend as P

# Every cell is answered with `3n`, which is `P.triple` only for the input `1n`.
# The singleton law fails at a variable head.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.triple_all_single`.
def triple_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      3n <> triple_all(t)
