# `half` answers two more than the half of the number two below.
#
# The match's three cases are the reference's and the walk still takes two units
# at a time; only the constant the step adds is wrong. It type-checks, and it is
# the law that says the step adds one that catches it.
#
# Measured 2026-09-19 against this task's law set: tier 3, proving
# `half_zero`, `half_one` and failing `half_step`, `half_double`,
# `half_double_succ`.
import Base
import ./prelude.bend as P

def half(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+0n:
      0n
    case 1n+1n+p:
      2n + half(p)
