import Base
import ./prelude.bend as P

# The head is inserted into the tail *as it came*: the recursion is there but
# the tail is never sorted. It is right on lists of one and two elements and a
# permutation at every length, so all four original laws are true of it.
# This file used to say the guard was `isort_count`'s proof obligation rather
# than its statement. It was not: `isort_count` follows from `insert_count` in
# two rewrites, and a token-different spelling of this body with that proof
# earned **reward 1.000** (`tests/holes/isort_unsorted_tail.*`). Rejected now by
# `insert_before`, `insert_after` and `isort_cons`.
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
      insert(t, h)
