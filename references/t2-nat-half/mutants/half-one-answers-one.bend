# `half` answers one for a single unit.
#
# This file exists for a law that no other mutant in the corpus fails. The
# unit is the match's other answer, the one it gives without recursing: the
# recursion is the reference's at every larger number, so nothing but the law
# about `1n` looks at this case.
#
# Measured 2026-09-19 against this task's law set: tier 3, proving
# `half_zero`, `half_step`, `half_double` and failing `half_one`,
# `half_double_succ`.
import Base
import ./prelude.bend as P

def half(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+0n:
      1n
    case 1n+1n+p:
      1n + half(p)
