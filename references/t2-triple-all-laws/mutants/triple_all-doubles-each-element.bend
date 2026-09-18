import Base
import ./prelude.bend as P

# Each element is doubled instead of tripled: `h + h` instead of `P.triple(h)`.
# The singleton law refuses it at a variable head, since `h + h` and
# `P.triple(h)` are different terms.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.triple_all_single`.
def triple_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +h2 = h
      (h2 + h2) <> triple_all(t)
