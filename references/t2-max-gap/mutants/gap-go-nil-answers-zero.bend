import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `gap_go_nil` (and, through the induction's base case,
# `gap_go_same`). The walk's empty case has nothing left to measure, so it
# answers the largest distance it was carrying; this body answers `0n` instead,
# which is the reading that the answer is *a* gap rather than the largest one
# seen -- it agrees with the reference on every list whose last window happens to
# hold the largest distance, which is why it survives the step law and the
# closed law and is separated only by the empty case and by the run of equal
# elements, whose base case is the empty list too.
#
# Measured 2026-09-19, same command as the other hand mutants: **tier 3**,
# `laws_failed = ["gap_go_nil", "gap_go_same", "max_gap_three"]` -- the walk's
# empty case, the induction whose base case is that empty list, and the closed
# list whose largest distance is not its last one. `gap_go_nil` had no other
# killer.
def gap_go(xs: List<&2, Nat>, prev: Nat, best: Nat) -> Nat:
  match xs:
    case Nil{}:
      0n
    case +h <> t:
      gap_go(t, h, Nat.max(P.absdiff(prev, h), best))

def max_gap(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      gap_go(t, h, 0n)
