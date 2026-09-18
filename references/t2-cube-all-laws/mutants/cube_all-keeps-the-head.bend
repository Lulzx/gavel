import Base
import ./prelude.bend as P

# The head is copied through unmapped and only the tail is mapped: the
# `P.cube` is missing from the first cell.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.cube_all_single`.
def cube_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> cube_all(t)
