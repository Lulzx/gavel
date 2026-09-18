import Base
import ./prelude.bend as P

# Each element is squared but the `+ 1n` is dropped: the constant is left off
# the map. The singleton law refuses it at a variable head, where `h * h` and
# `P.sq_inc(h)` are different terms.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.sq_inc_all_single`.
def sq_inc_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +h2 = h
      Nat.mul(h2, h2) <> sq_inc_all(t)
