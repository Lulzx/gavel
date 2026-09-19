# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g3.json check
# t2-count-divisors --solution
# references/t2-count-divisors/mutants/count-divisors-base-answers-one.bend
# --proof references/t2-count-divisors/PROOF.bend --backend plain --json`:
# **tier 3**, laws_failed = [cd_go_zero, count_divisors_one, count_divisors_seven,
# count_divisors_twelve]. The walk stops one higher than it should: the empty
# tail contributes `1n` instead of `0n`, so every count is one too large.
# `cd_go_zero` is the law that sees it at the stop itself, where no other law
# looks, and `count_divisors_one` sees it at the smallest closed value.
import Base
import ./prelude.bend as P

def cd_go(+n: Nat, +k: Nat) -> Nat:
  match k:
    case 0n:
      1n
    case 1n+kp:
      Bool.pick(Nat, P.divides(n, k), 1n, 0n) + cd_go(n, kp)

def count_divisors(+n: Nat) -> Nat:
  cd_go(n, n)
