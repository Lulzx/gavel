import Base
import ./prelude.bend as P

# A one-element list answers one sum.
#
# The one element has no successive pair, so the answer is `Nil{}`; this is the
# reference with the *inner* match's empty case given a cell, which is the case
# a one-element list reaches. Nothing else moves, so it type-checks and every
# recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `sum_adjacent_single`, `sum_adjacent_pair`, `sum_adjacent_len`,
# `sum_adjacent_three`. Every law whose input ends here sees the extra cell: the
# pair law because the walk over two elements ends in this case, and the other
# two because a cell that is not the sum of a pair is one cell too many.
def sum_adjacent(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      match t:
        case Nil{}:
          1n <> Nil{}
        case +k <> u:
          h + k <> sum_adjacent(k <> u)
