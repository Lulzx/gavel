import Base
import ./prelude.bend as P

# `collatz_len` sends `1n` on to `4n` -- which is what one Collatz step does
# with it -- instead of stopping there.
#
# This file exists for a law that no generated mutant fails. The corpus's
# mutants that type-check rewrite a recursive step or swap case bodies, and the
# arm that answers `1n` is an answer a match that has already stopped gives, so
# no step rewrite reaches it; `collatz_len_one` was killed only by corpus
# entries that fail to type-check. This is the reference with that one case
# given a non-empty answer, so it type-checks and every recursive call is
# untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `collatz_len_one`, `collatz_len_six`, `collatz_len_fifteen`.
def collatz_len(fuel: Nat, +n: Nat) -> Nat:
  match fuel:
    case 0n:
      0n
    case 1n+f:
      match n:
        case 0n:
          0n
        case 1n+0n:
          4n
        case 1n+1n+p:
          1n + collatz_len(f, Bool.pick(Nat, P.is_even_b(n), P.half(n), Nat.mul(3n, n) + 1n))
