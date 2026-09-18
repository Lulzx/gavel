import Base
import ./prelude.bend as P

# The head is copied through unmapped and only the tail is mapped.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.sq_inc_all_single`.
def sq_inc_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> sq_inc_all(t)
