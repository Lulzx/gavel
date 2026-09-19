import Base
import ./prelude.bend as P

# `map_len` answers a one-element list on the empty list of rows.
#
# This file exists for `map_len_nil`, which no other mutant in the corpus
# fails. The empty case of a list recursion is an *answer*, reached by a match
# that has already stopped, so the generated rules -- which rewrite a step --
# have nothing to rewrite in it, and every one of them leaves it alone.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `map_len_nil`.
def map_len(xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  match xss:
    case Nil{}:
      0n <> Nil{}
    case l <> t:
      P.len(l) <> map_len(t)

def longest_row(xss: List<&2, List<&2, Nat>>) -> Nat:
  match xss:
    case Nil{}:
      0n
    case l <> t:
      P.max(P.len(l), longest_row(t))
