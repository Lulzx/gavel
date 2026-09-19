import Base
import ./prelude.bend as P

# `swap_adjacent` answers a one-element list at `Nil{}`.
#
# This file exists for the empty case, which no generated mutant reaches: the
# generator rewrites a step, and `Nil{}` is an answer reached by a match that
# has already stopped. It is the reference with the empty case given a
# non-empty answer, so it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `swap_adjacent_nil`, `swap_adjacent_len`, `swap_adjacent_involutive`.
def swap_adjacent(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case x <> t:
      match t:
        case Nil{}:
          x <> Nil{}
        case y <> t2:
          y <> (x <> swap_adjacent(t2))
