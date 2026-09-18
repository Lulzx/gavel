import Base
import ./prelude.bend as P

# The head is copied through unreduced and only the tail is mapped, which is
# the reference with the map left off the first cell.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.mod5_all_single`.
def mod5_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> mod5_all(t)
