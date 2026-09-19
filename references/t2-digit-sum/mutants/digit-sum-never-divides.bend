import Base
import ./prelude.bend as P

# `digit_sum` reads the low digit at every step but never divides the number
# down, so the recursive call gets `n` unchanged: the branch is `Nat.mod(n, 10n)
# + digit_sum(p, n)`.
#
# The width still shrinks, so the recursion terminates and the body type-checks;
# what is wrong is that every unit of width looks at the same digit. On `123n`
# this answers `3n + 3n + 3n`, and on `1000n` it answers `0n` where the sum is
# `1n`, which is the pair of closed laws pulling in opposite directions.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `digit_sum_step`, `digit_sum_123`, `digit_sum_thousand`.
def digit_sum(w: Nat, +n: Nat) -> Nat:
  match w:
    case 0n:
      0n
    case 1n+p:
      Nat.mod(n, 10n) + digit_sum(p, n)
