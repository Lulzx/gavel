import Base

# The step recurses on the tail and never puts the head back, so `inc_all` of
# a nonempty list is `Nil{}`. The singleton law refuses it.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.inc_all_single`.
def inc_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      inc_all(t)
