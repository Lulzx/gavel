import Base
import ./prelude.bend as P

# `isort` sorts the tail and never inserts the head, so it answers `Nil{}` on
# every list. The sortedness *statement* is true of it -- `Nil{}` is sorted --
# so this body is a probe for whether the sort law can tell "sorted" from
# "the sort". Measured: `proof_tier=3 bare_tier=2`, `insert_sorted`,
# `insert_le`, `insert_gt` proven and `isort_sorted` failing first, with
# `isort_swap` failing too. The refusal is at the proof obligation, not the
# statement: the sortedness proof is induction over the reference's own
# recursion and does not replay against a body that discards the head's
# insertion. In the sibling permutation task the same body is caught by the
# count law instead; keeping both is what makes the pair informative.
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
      isort(t)
