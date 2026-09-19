import Base
import ./prelude.bend as P

# `digit_sum` answers `1n` on an exhausted width instead of `0n`.
#
# This file exists for a law that no generated mutant fails. The corpus's
# mutants that type-check rewrite a recursive step or swap case bodies, and the
# exhausted-width arm is an answer a match that has already stopped gives -- it
# never recurses, so no step rewrite reaches it, and `digit_sum_no_fuel` was
# killed only by corpus entries that fail to type-check. This is the reference
# with that one case given a non-empty answer, so it type-checks and every
# recursive call is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `digit_sum_no_fuel`, `digit_sum_123`, `digit_sum_thousand`.
def digit_sum(w: Nat, +n: Nat) -> Nat:
  match w:
    case 0n:
      1n
    case 1n+p:
      Nat.mod(n, 10n) + digit_sum(p, Nat.div(n, 10n))
