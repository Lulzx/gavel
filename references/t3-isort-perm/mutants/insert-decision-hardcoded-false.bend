import Base
import ./prelude.bend as P

# The mirror of the hard-coded `True{}`: the decision is always `False{}`, so
# the element is placed after the head it meets and `insert` appends. With the
# empty case and the recursion intact, the count law still holds and it is
# `isort_keep` that fails -- the two-element list that was already in order
# comes back reversed. Together with the `True{}` body this pins the direction
# of the decision from both sides. Measured: rejected at `Policy.count_ins`, the
# count law's helper, with all four laws reported unproven.
def insert(xs: List<&2, Nat>, +y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      y <> Nil{}
    case +h <> t:
      P.insert_put(t, h, y, False{})

def isort(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      insert(isort(t), h)
