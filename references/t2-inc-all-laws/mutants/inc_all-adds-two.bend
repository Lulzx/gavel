import Base

# Each element is incremented by two: the successor is written twice, a slip
# that is invisible while the element is `0n` in the writer's head. The
# singleton law asks for `h + 1n`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.inc_all_single`.
def inc_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      (h + 2n) <> inc_all(t)
