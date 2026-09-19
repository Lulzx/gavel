# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g3.json check
# t2-count-divisors --solution
# references/t2-count-divisors/mutants/count-divisors-counts-every-k.bend
# --proof references/t2-count-divisors/PROOF.bend --backend plain --json`:
# **tier 3**, laws_failed = [cd_go_step, count_divisors_seven,
# count_divisors_twelve]. Every number below the walk's start is counted, so the
# answer is the size of the range rather than the number of divisors in it.
# `cd_go_step` is the definition written out and catches this directly;
# `count_divisors_one` is the one closed value this agrees with, since `1n` is
# its own only divisor.
import Base
import ./prelude.bend as P

def cd_go(+n: Nat, +k: Nat) -> Nat:
  match k:
    case 0n:
      0n
    case 1n+kp:
      1n + cd_go(n, kp)

def count_divisors(+n: Nat) -> Nat:
  cd_go(n, n)
