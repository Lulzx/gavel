# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g3.json check
# t2-nat-log2 --solution
# references/t2-nat-log2/mutants/log2-go-no-fuel-answers-one.bend --proof
# references/t2-nat-log2/PROOF.bend --backend plain --json`: **tier 3**,
# laws_failed = [log2_go_no_fuel, log2_go_zero, nat_log2_zero]. The
# exhausted-width arm answers `1n` instead of `0n`. Two other laws reach it
# through their own base cases rather than through a closed value:
# `nat_log2(0n)` starts the walk at width `0n`, and `log2_go_zero`'s induction
# takes its zero arm at `w = 0n`. So the two laws about the zero answer are both
# about this one arm, and no mutant can fail `nat_log2_zero` while the hand-off
# holds without failing this arm.
import Base
import ./prelude.bend as P

def log2_go(w: Nat, +n: Nat) -> Nat:
  match w:
    case 0n:
      1n
    case 1n+p:
      match n:
        case 0n:
          0n
        case 1n+0n:
          0n
        case 1n+1n+q:
          1n + log2_go(p, P.half(1n + 1n + q))

def nat_log2(+n: Nat) -> Nat:
  log2_go(n, n)
