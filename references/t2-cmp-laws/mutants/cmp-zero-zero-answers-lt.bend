import Base
import ./prelude.bend as P

# `cmp` answers `Lt{}` on two zeroes.
#
# This file exists for a law that the generated corpus reaches only by
# accident: `cmp_zero_zero`'s left-hand side is the ground term
# `cmp(0n, 0n)`, so the match has already stopped and there is no step left
# for a rule-based rewrite to change. It is the reference with that one leaf
# given the other answer, so it type-checks and every recursive step is
# untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3 (partial), failing
# `cmp_zero_zero`, `cmp_self`, `cmp_antisym`.
def cmp(a: Nat, b: Nat) -> P.Tri:
  match a:
    case 0n:
      match b:
        case 0n:
          P.Lt{}
        case 1n+q:
          P.Lt{}
    case 1n+p:
      match b:
        case 0n:
          P.Gt{}
        case 1n+q:
          cmp(p, q)
