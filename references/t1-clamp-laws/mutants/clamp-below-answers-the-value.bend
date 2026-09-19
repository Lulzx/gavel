import Base
import ./prelude.bend as P

# The `True{}` case of the first test answers the value instead of the lower
# bound.
#
# This file exists for a law no generated mutant isolates: `clamp_below`'s
# left-hand side is the stopped-match form `clamp(x, lo, hi, True{}, khi)`, so
# the outer match has already taken its case and no rule-based rewrite can
# reach inside it. It is the reference with that one case's body moved, so it
# type-checks and the second test is untouched -- which is what makes it say
# something about `clamp_below` alone.
#
# Measured 2026-09-19 against this task's law set: tier 3 (partial), failing
# `clamp_below`.
def clamp(x: Nat, lo: Nat, hi: Nat, klo: Bool, khi: Bool) -> Nat:
  match klo:
    case True{}:
      x
    case False{}:
      match khi:
        case True{}:
          hi
        case False{}:
          x
