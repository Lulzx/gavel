import Base
import ./prelude.bend as P

# Each element is moved forward by three instead of two: the constant is
# wrong, which is invisible while the writer has `0n` in mind. The singleton
# law refuses it at a variable head.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.succ2_all_single`.
def succ2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      Nat.add(h, 3n) <> succ2_all(t)
