import Base
import ./prelude.bend as P

# `snoc_each` answers a one-row list on the empty list of rows.
#
# This file exists for `snoc_each_nil`, which no other mutant in the corpus
# fails. The empty case of a list recursion is an *answer*, reached by a match
# that has already stopped, so the generated rules -- which rewrite a step --
# have nothing to rewrite in it, and every one of them leaves it alone.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `snoc_each_nil`, `snoc_front_commute`.
def snoc_each(xss: List<&2, List<&2, Nat>>, +y: Nat) -> List<&2, List<&2, Nat>>:
  match xss:
    case Nil{}:
      P.snoc(Nil{}, y) <> Nil{}
    case l <> t:
      P.snoc(l, y) <> snoc_each(t, y)

def front_each(xss: List<&2, List<&2, Nat>>, +y: Nat) -> List<&2, List<&2, Nat>>:
  match xss:
    case Nil{}:
      Nil{}
    case l <> t:
      (y <> l) <> front_each(t, y)
