import Base
import ./prelude.bend as P

# `swap_each` answers a one-record list on the empty list.
#
# This file exists for `swap_each_nil`, which no other mutant in the corpus
# fails. The empty case of a list recursion is an *answer*, reached by a match
# that has already stopped, so the generated rules -- which rewrite a step --
# have nothing to rewrite in it, and every one of them leaves it alone.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `swap_each_nil`, `swap_each_swap_each`.
def swap_each(ps: List<&2, P.Pair>) -> List<&2, P.Pair>:
  match ps:
    case Nil{}:
      P.MkPair{0n, 0n} <> Nil{}
    case P.MkPair{a, b} <> t:
      P.MkPair{b, a} <> swap_each(t)

def sum_pair(ps: List<&2, P.Pair>) -> Nat:
  match ps:
    case Nil{}:
      0n
    case P.MkPair{a, b} <> t:
      a + (b + sum_pair(t))
