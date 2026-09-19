import Base
import ./prelude.bend as P

# `indexed_go` keeps every position right and writes each element's successor
# into the pair instead of the element.
#
# This file exists to give `indexed_elems` a killer that is not the generated
# constant-body mutant, which fails three laws at once and so says nothing about
# which of them carries the content. It is the reference with `h` replaced by
# `h + 1n` in the pair, so it type-checks, it numbers every position correctly,
# and its answers are exactly as long as the input -- it passes `indexed_zero`
# and `indexed_len` and fails the two laws that name the element.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `indexed_cons` and `indexed_elems`.
def indexed_go(xs: List<&2, Nat>, +i: Nat) -> List<&2, P.Indexed>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.MkIndexed{i, h + 1n} <> indexed_go(t, i + 1n)

def indexed(xs: List<&2, Nat>) -> List<&2, P.Indexed>:
  indexed_go(xs, 0n)
