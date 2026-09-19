# `half` answers one for nothing.
#
# This file exists for a law that no other mutant in the corpus fails.
# It is the reference with the empty case given a non-empty answer, so
# it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, proving
# `half_one`, `half_step`, `half_double_succ` and failing `half_zero`,
# `half_double`.
import Base
import ./prelude.bend as P

def half(n: Nat) -> Nat:
  match n:
    case 0n:
      1n
    case 1n+0n:
      0n
    case 1n+1n+p:
      1n + half(p)
