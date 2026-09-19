# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g3.json check
# t2-nat-log2 --solution
# references/t2-nat-log2/mutants/nat-log2-starts-at-a-fixed-width.bend --proof
# references/t2-nat-log2/PROOF.bend --backend plain --json`: **tier 3**,
# laws_failed = [nat_log2_handoff]. The walk is started at the constant width
# `8n` instead of at `n`. Every closed value still agrees -- `8n` is wide enough
# for all of them -- so this is the mutant that shows the hand-off law carries
# the whole of "the answer is a function of `n`": a body that returned the width
# it was handed would be indistinguishable from the reference by value alone.
import Base
import ./prelude.bend as P

def log2_go(w: Nat, +n: Nat) -> Nat:
  match w:
    case 0n:
      0n
    case 1n+p:
      match n:
        case 0n:
          0n
        case 1n+0n:
          0n
        case 1n+1n+q:
          1n + log2_go(p, P.half(1n + 1n + q))

def nat_log2(+n: Nat) -> Nat:
  log2_go(8n, n)
