import Base
import ./prelude.bend as P

# `count_if` answers one on the empty list.
#
# This file exists for the empty case, which no generated mutant reaches: the
# generator rewrites a step, and `0n` is an answer reached by a match that has
# already stopped. It is the reference with the `Nil{}` case given a non-empty
# answer, so it type-checks and every record in the list is counted as the
# reference counts it.
#
# Measured against this task's law set: tier 3, failing `count_if_nil`,
# `count_if_snoc`.
def count_if(ps: List<&2, P.Pair>) -> Nat:
  match ps:
    case Nil{}:
      1n
    case P.MkPair{a, b} <> t:
      P.same(a, b) + count_if(t)
