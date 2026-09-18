import Base
import ./prelude.bend as P

# The head is copied through unmapped and only the tail is mapped: the
# `P.triple` is missing from the first cell.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.triple_all_single`.
def triple_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> triple_all(t)
