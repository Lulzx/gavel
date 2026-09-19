import Base
import ./prelude.bend as P

# `is_pow2` recurses without testing parity: the `1n + 1n + q` arm is
# `is_pow2(p, P.half(n))` where the reference is
# `Bool.and(P.is_even_b(n), is_pow2(p, P.half(n)))`.
#
# This is the body the closed value `6n` is in the law set for. The halving is
# untouched, so the walk still terminates and every power of two still comes out
# `True{}` -- `4n` halves to `2n` halves to `1n` either way. What changes is the
# even-but-not-a-power-of-two answer: `6n` halves to `3n`, which is odd, and the
# dropped parity test lets the walk carry on to `1n` and answer `True{}`.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `is_pow2_step`, `is_pow2_six`.
def is_pow2(w: Nat, +n: Nat) -> Bool:
  match w:
    case 0n:
      False{}
    case 1n+p:
      match n:
        case 0n:
          False{}
        case 1n+0n:
          True{}
        case 1n+1n+q:
          is_pow2(p, P.half(n))
