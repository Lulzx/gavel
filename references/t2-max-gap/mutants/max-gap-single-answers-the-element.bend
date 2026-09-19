import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `max_gap_single`. One element has no *neighbour*, so
# there is no distance to take and the answer is `0n`; this body answers the
# element itself there -- the reading that an element with nothing beside it is
# as far from the void as it is large. The case has to be spelled out to be
# reached at all: the reference's single-element answer comes out of the walk's
# empty case, so a body that only rewrote the walk could not change it. Nothing
# else here reads a list of exactly one element.
#
# Measured 2026-09-19, same command as the other hand mutants: **tier 3**,
# `laws_failed = ["max_gap_single", "max_gap_cons"]`. `max_gap_single` had no
# other killer; `max_gap_cons` fails because the extra case is not the opening
# step the reference proof is written against.
def gap_go(xs: List<&2, Nat>, prev: Nat, best: Nat) -> Nat:
  match xs:
    case Nil{}:
      best
    case +h <> t:
      gap_go(t, h, Nat.max(P.absdiff(prev, h), best))

def max_gap(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case x <> Nil{}:
      x
    case h <> t:
      gap_go(t, h, 0n)
