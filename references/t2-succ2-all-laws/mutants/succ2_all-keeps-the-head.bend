import Base
import ./prelude.bend as P

# The head is passed through unmapped and only the tail is mapped.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.succ2_all_single`.
def succ2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> succ2_all(t)
