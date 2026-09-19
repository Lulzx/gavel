# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g3.json check
# t2-is-prime --solution
# references/t2-is-prime/mutants/is-prime-gate-drops-the-one.bend --proof
# references/t2-is-prime/PROOF.bend --backend plain --json`: **tier 3**,
# laws_failed = [is_prime_one]. The gate has a single arm, so `1n` falls through
# to the walk started at `1n - 1n`, which is `0n` -- the stop -- and the answer
# is `True{}`. `is_prime_one` is the only law that sees it: `0n` still reaches
# the rejecting arm, and every value from `2n` up starts its walk in the same
# place the reference does.
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
      False{}
    case 1n+p:
      no_divisor(n, p)
