# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g3.json check
# t2-is-prime --solution
# references/t2-is-prime/mutants/is-prime-gate-accepts-zero.bend --proof
# references/t2-is-prime/PROOF.bend --backend plain --json`: **tier 3**,
# laws_failed = [is_prime_zero]. The gate rejects `1n` and lets `0n` through to
# the non-trivial arm, which then finds no candidate below `0n` and answers
# `True{}`. `is_prime_zero` is the only law that sees it: every closed value
# above agrees, and the hand-off is untouched because `2n + n` never reaches
# this arm. Recorded here because no generated strong mutant fails
# `is_prime_zero`: the two that rewrite `is_prime` are caught by
# `is_prime_two` and `is_prime_seven` instead.
import Base
import ./prelude.bend as P

def no_divisor(+n: Nat, +k: Nat) -> Bool:
  match k:
    case 0n:
      True{}
    case 1n+kp:
      match kp:
        case 0n:
          True{}
        case 1n+j:
          Bool.and(Bool.not(P.divides(n, k)), no_divisor(n, kp))

def is_prime(+n: Nat) -> Bool:
  match n:
    case 0n:
      True{}
    case 1n+p:
      match p:
        case 0n:
          False{}
        case 1n+q:
          no_divisor(n, 1n + q)
