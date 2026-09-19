import Base
import ./prelude.bend as P

# Hand-written, for `positions_hit`. The body is the reference with the *hit*
# arm rewritten: a head equal to the target shifts the tail's positions along
# like any other element and records nothing of its own, so the answer is right
# for the elements after the first match and one short from there on. It is the
# reading in which the comparison decides only whether to *skip* an element, and
# the step law cannot see it: `positions_step` is stated at a variable head and
# never unfolds the comparison.
#
# Measured 2026-09-19 against the four-law set: **tier 3, two laws unproven --
# `positions_step`, whose hit arm the reference proof reads as `0n <> ...` where
# this body answers the shifted tail, and `positions_hit`, which this file is
# for.** `positions_nil` and `positions_miss` proven: the answer is right at
# every list in which the target does not occur, which is what makes this body
# the one the hit law exists for.
def positions(+x: Nat, xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> +t:
      P.at_if(P.eq(h, x), P.inc_all(positions(x, t)), P.inc_all(positions(x, t)))
