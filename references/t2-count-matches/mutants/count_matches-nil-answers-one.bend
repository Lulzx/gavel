import Base
import ./prelude.bend as P

# `count_matches` answers `1n` when there is nothing left of the first list.
#
# This file exists for a law that no other mutant in the corpus fails. It is
# the reference with the outer stopped match's answer flipped, so it
# type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `count_matches_nil`, `count_matches_self`.
def count_matches(xs: List<Nat>, ys: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      match ys:
        case Nil{}:
          0n
        case k <> u:
          P.pick(P.eq(h, k), 1n, 0n) + count_matches(t, u)
