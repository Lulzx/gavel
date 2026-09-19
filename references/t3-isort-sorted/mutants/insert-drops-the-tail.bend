import Base
import ./prelude.bend as P

# Wrong: the cons step of `insert` hands the prelude's helper an empty list
# instead of the tail it matched, so every insertion into a list of two or more
# elements keeps the head and answers a two-element list -- `isort([1n, 2n, 3n])`
# drops an element. Every element that survives is still in the right place, so
# nothing about order notices: the answer is sorted for `isort_sorted` and
# `insert_sorted`, `insert_le` and `insert_gt` only ever apply `insert` to the
# one-element list `x <> Nil{}`, where the tail handed to the helper *is* the
# empty list, and `isort_swap`'s two-element argument reaches the same place.
# `insert_len` is the law that rules it out: the answer to a three-element
# insert has two elements here and the law asks for four.
def insert(xs: List<&2, Nat>, +y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      y <> Nil{}
    case +h <> t:
      P.insert_put(Nil{}, h, y, P.le(y, h))

def isort(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      insert(isort(t), h)
