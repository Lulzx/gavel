import Base
import ./prelude.bend as P

# `is_pow2` answers `False{}` on the `1n` arm instead of `True{}`.
#
# This is the other half of the stopped-answer pair. The `1n` arm is where the
# walk ends when the number really is a power of two -- it does not recurse, so
# no step rewrite reaches it -- and both `is_pow2_one` and `is_pow2_four` fall
# to it. The even-but-not-a-power-of-two law does not: `6n` is decided by the
# parity term before this arm is ever read, which is why the two closed values
# pull in opposite directions.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `is_pow2_one`, `is_pow2_four`.
def is_pow2(w: Nat, +n: Nat) -> Bool:
  match w:
    case 0n:
      False{}
    case 1n+p:
      match n:
        case 0n:
          False{}
        case 1n+0n:
          False{}
        case 1n+1n+q:
          Bool.and(P.is_even_b(n), is_pow2(p, P.half(n)))
