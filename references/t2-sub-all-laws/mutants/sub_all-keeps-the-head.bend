import Base
import ./prelude.bend as P

# The head is copied through unreduced and only the tail is reduced: the
# `P.sub` is missing from the first cell.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.sub_all_single`.
def sub_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> sub_all(t, n)
