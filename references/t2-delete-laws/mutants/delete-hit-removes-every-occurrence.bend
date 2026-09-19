import Base
import ./prelude.bend as P

# Hand-written, for `delete_hit`. The body is the reference with the *hit* arm
# rewritten: instead of answering the tail and stopping, it goes on removing
# from the tail, so every occurrence of the target goes rather than the first.
# This is the reading of "delete" the task's prose rules out, and it is the one
# a reader is most likely to reach for.
#
# Measured 2026-09-19 against the four-law set: **tier 3, two laws unproven --
# `delete_step`, whose hit arm the reference proof reads as `t` where this body
# answers `delete(x, t)`, and `delete_hit`, which this file is for.** `delete_nil`
# and `delete_miss` proven: reading the hit law off the step law alone would have
# missed it, because `delete_step` is stated at a variable head and never unfolds
# the comparison.
def delete(+x: Nat, xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> +t:
      P.at_if(P.eq(h, x), delete(x, t), h <> delete(x, t))
