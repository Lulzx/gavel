# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g3.json check
# t2-nat-log2 --solution
# references/t2-nat-log2/mutants/log2-go-zero-arm-answers-one.bend --proof
# references/t2-nat-log2/PROOF.bend --backend plain --json`: **tier 3**,
# laws_failed = [log2_go_zero]. The inner `0n` arm answers `1n`. No closed value
# reaches it: `nat_log2(0n)` is decided by the width-zero arm instead, and every
# other value starts at `1n` or above. So `log2_go_zero` -- the law stated at a
# variable width with `0n` as the number -- is the only thing that measures this
# arm, which is why the corpus needs it by hand.
import Base
import ./prelude.bend as P

def log2_go(w: Nat, +n: Nat) -> Nat:
  match w:
    case 0n:
      0n
    case 1n+p:
      match n:
        case 0n:
          1n
        case 1n+0n:
          0n
        case 1n+1n+q:
          1n + log2_go(p, P.half(1n + 1n + q))

def nat_log2(+n: Nat) -> Nat:
  log2_go(n, n)
