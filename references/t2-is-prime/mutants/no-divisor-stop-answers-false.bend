# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g3.json check
# t2-is-prime --solution
# references/t2-is-prime/mutants/no-divisor-stop-answers-false.bend --proof
# references/t2-is-prime/PROOF.bend --backend plain --json`: **tier 3**,
# laws_failed = [no_divisor_zero]. The walk's outermost stop answers `False{}`
# instead of `True{}`. Only `no_divisor_zero` reaches that arm: the `1n` stop is
# a different arm and is untouched, and `is_prime` never starts the walk at `0n`
# for any `n` at least `2n`, so every closed value and the hand-off agree.
# Recorded here because it is the sole measurement of the outermost stop.
import Base
import ./prelude.bend as P

def no_divisor(+n: Nat, +k: Nat) -> Bool:
  match k:
    case 0n:
      False{}
    case 1n+kp:
      match kp:
        case 0n:
          True{}
        case 1n+j:
          Bool.and(Bool.not(P.divides(n, k)), no_divisor(n, kp))

def is_prime(+n: Nat) -> Bool:
  match n:
    case 0n:
      False{}
    case 1n+p:
      match p:
        case 0n:
          False{}
        case 1n+q:
          no_divisor(n, 1n + q)
