import Base
import ./prelude.bend as P

# `is_prefix` answers `False{}` when there is nothing left of the first list.
#
# This file exists for a law that no other mutant in the corpus fails. It is
# the reference with the stopped match's answer flipped, so it type-checks and
# every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `is_prefix_nil`, `is_prefix_append`, `is_prefix_self`.
def is_prefix(xs: List<Nat>, ys: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      match ys:
        case Nil{}:
          False{}
        case k <> u:
          Bool.and(P.eq(h, k), is_prefix(t, u))
