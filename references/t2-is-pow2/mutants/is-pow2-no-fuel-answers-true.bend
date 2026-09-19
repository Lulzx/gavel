import Base
import ./prelude.bend as P

# `is_pow2` answers `True{}` on an exhausted width instead of `False{}`.
#
# This file exists for a law that no generated mutant fails. The corpus's
# mutants that type-check rewrite a recursive step or swap case bodies, and the
# exhausted-width arm is an answer a match that has already stopped gives -- it
# never recurses, so no step rewrite reaches it, and `is_pow2_no_fuel` was
# killed only by corpus entries that fail to type-check. This is the reference
# with that one case given the other answer, so it type-checks and every
# recursive call is untouched. It also reaches the width-zero case of
# `is_pow2_zero`, which the same stopped arm covers.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `is_pow2_no_fuel`, `is_pow2_zero`.
def is_pow2(w: Nat, +n: Nat) -> Bool:
  match w:
    case 0n:
      True{}
    case 1n+p:
      match n:
        case 0n:
          False{}
        case 1n+0n:
          True{}
        case 1n+1n+q:
          Bool.and(P.is_even_b(n), is_pow2(p, P.half(n)))
