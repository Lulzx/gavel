import Base
import ./prelude.bend as P

# `collatz_len` answers `1n` on an exhausted budget instead of `0n`.
#
# This file exists for a law that no generated mutant fails. The corpus's
# mutants that type-check rewrite a recursive step or swap case bodies, and the
# exhausted-budget arm is an answer a match that has already stopped gives -- it
# never recurses, so no step rewrite reaches it, and `collatz_len_no_fuel` was
# killed only by corpus entries that fail to type-check. This is the reference
# with that one case given a non-empty answer, so it type-checks and every
# recursive call is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `collatz_len_no_fuel`, `collatz_len_zero`, `collatz_len_one`.
def collatz_len(fuel: Nat, +n: Nat) -> Nat:
  match fuel:
    case 0n:
      1n
    case 1n+f:
      match n:
        case 0n:
          0n
        case 1n+0n:
          0n
        case 1n+1n+p:
          1n + collatz_len(f, Bool.pick(Nat, P.is_even_b(n), P.half(n), Nat.mul(3n, n) + 1n))
