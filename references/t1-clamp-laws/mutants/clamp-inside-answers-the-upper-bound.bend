import Base
import ./prelude.bend as P

# The `False{}` case of the second test answers the upper bound instead of the
# value.
#
# This file exists for a law no generated mutant isolates: `clamp_inside`'s
# left-hand side is the stopped-match form `clamp(x, lo, hi, False{}, False{})`,
# so both matches have already taken their cases. It is the reference with that
# one case's body moved, so it type-checks and the other two branches are
# untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3 (partial), failing
# `clamp_inside`.
def clamp(x: Nat, lo: Nat, hi: Nat, klo: Bool, khi: Bool) -> Nat:
  match klo:
    case True{}:
      lo
    case False{}:
      match khi:
        case True{}:
          hi
        case False{}:
          hi
