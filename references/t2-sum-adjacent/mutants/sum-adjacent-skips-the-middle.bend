import Base
import ./prelude.bend as P

# The walk restarts one element too far along.
#
# Each sum is still the sum of two neighbours, but the pair after the first
# starts at the third element rather than the second, so every sum after the
# first pairs the wrong two elements: three elements answer one sum instead of
# two. This is the hand-written mutant the ground law `sum_adjacent_three`
# needs, and it is also the law that separates the two readings of where the
# recursion restarts. The recursive argument still shrinks, so it type-checks.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `sum_adjacent_cons`, `sum_adjacent_len`, `sum_adjacent_three`.
def sum_adjacent(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      match t:
        case Nil{}:
          Nil{}
        case +k <> u:
          h + k <> sum_adjacent(u)
