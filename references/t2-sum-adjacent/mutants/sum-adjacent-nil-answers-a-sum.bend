import Base
import ./prelude.bend as P

# The empty input answers one sum.
#
# This file exists for a law that no other mutant in the corpus fails: the
# generator rewrites a *step*, and the walk's `Nil{}` case is an answer reached
# by a match that has already stopped. It is the reference with that one case
# given a cell, so it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `sum_adjacent_nil`.
def sum_adjacent(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      1n <> Nil{}
    case +h <> t:
      match t:
        case Nil{}:
          Nil{}
        case +k <> u:
          h + k <> sum_adjacent(k <> u)
