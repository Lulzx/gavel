import Base
import ./prelude.bend as P

# The head is put back in front of the sorted tail: `insert` is never called,
# so `isort` is the identity on every list and an unordered input comes back
# unordered. This is the body the sortedness law exists for -- its statement is
# false of it at any two-element list whose pair is out of order. Measured:
# `proof_tier=3 bare_tier=2`, `insert_sorted`, `insert_le`, `insert_gt` proven
# and `isort_sorted` failing first, `isort_swap` failing with it. The insert
# laws are proven because the reference's `insert` is left untouched; only the
# `isort` laws see the identity body.
def insert(xs: List<&2, Nat>, +y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      y <> Nil{}
    case +h <> t:
      P.insert_put(t, h, y, P.le(y, h))

def isort(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> isort(t)
