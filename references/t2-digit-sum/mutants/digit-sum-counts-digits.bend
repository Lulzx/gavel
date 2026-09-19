import Base
import ./prelude.bend as P

# `digit_sum` adds one per digit instead of the digit itself: the recursive
# branch is `1n + digit_sum(p, Nat.div(n, 10n))`, so the number is still divided
# by ten and the width is still the argument that shrinks, but the low digit is
# never read.
#
# The body type-checks and the recursion is well founded, which is what makes it
# worth its own file: a wrong answer that still terminates is the kind no
# generated mutant produces. It is the shape the closed value `1000n` is in the
# law set for -- counting answers `4n` there and `3n` on `123n`, and the sum is
# `1n` and `6n`.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `digit_sum_step`, `digit_sum_123`, `digit_sum_thousand`.
def digit_sum(w: Nat, +n: Nat) -> Nat:
  match w:
    case 0n:
      0n
    case 1n+p:
      1n + digit_sum(p, Nat.div(n, 10n))
