import Base
import ./prelude.bend as P

# `indexed` starts the count at `1n` instead of `0n`.
#
# This file exists for a law that no generated mutant in the corpus fails: the
# generator mutates one target at a time and produced only mutants of the
# helper, so `indexed_zero` -- the one law stated over `indexed` -- had no
# killer at all. It is the reference with the second target started at the wrong
# position, so it type-checks and every law stated over the helper is untouched.
# The helper is otherwise identical.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing `indexed_zero`.
def indexed_go(xs: List<&2, Nat>, +i: Nat) -> List<&2, P.Indexed>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.MkIndexed{i, h} <> indexed_go(t, i + 1n)

def indexed(xs: List<&2, Nat>) -> List<&2, P.Indexed>:
  indexed_go(xs, 1n)
