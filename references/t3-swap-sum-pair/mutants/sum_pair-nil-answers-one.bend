import Base
import ./prelude.bend as P

# `sum_pair` answers `1n` on the empty list.
#
# This file exists for `sum_pair_nil`, which no other mutant in the corpus
# fails. `sum_pair_nil` is the pin on the empty case, and the empty case is an
# *answer*: the generated rules rewrite a step, and there is no step here to
# rewrite. `sum_pair_cons` cannot see it either, since its left-hand side is a
# cons.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `sum_pair_nil`.
def swap_each(ps: List<&2, P.Pair>) -> List<&2, P.Pair>:
  match ps:
    case Nil{}:
      Nil{}
    case P.MkPair{a, b} <> t:
      P.MkPair{b, a} <> swap_each(t)

def sum_pair(ps: List<&2, P.Pair>) -> Nat:
  match ps:
    case Nil{}:
      1n
    case P.MkPair{a, b} <> t:
      a + (b + sum_pair(t))
