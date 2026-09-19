import Base
import ./prelude.bend as P

# `cmp` answers `Lt{}` for a successor against a zero.
#
# This file exists for a law that the generated corpus reaches only by
# accident: `cmp_succ_zero`'s left-hand side has the outer match stopped on a
# successor and the inner one stopped on a literal `0n`, so its answer is
# reached without a step. It is the reference with that one leaf given the
# other answer, so it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3 (partial), failing
# `cmp_succ_zero`, `cmp_antisym`.
def cmp(a: Nat, b: Nat) -> P.Tri:
  match a:
    case 0n:
      match b:
        case 0n:
          P.Eq{}
        case 1n+q:
          P.Lt{}
    case 1n+p:
      match b:
        case 0n:
          P.Lt{}
        case 1n+q:
          cmp(p, q)
