# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g3.json check
# t2-nat-log2 --solution
# references/t2-nat-log2/mutants/log2-go-one-arm-answers-one.bend --proof
# references/t2-nat-log2/PROOF.bend --backend plain --json`: **tier 3**,
# laws_failed = [log2_go_one, nat_log2_one, nat_log2_two, nat_log2_seven,
# nat_log2_eight]. `1n` spends a halving it should not, so every answer is one
# too large. `log2_go_one` is the law that names the arm, and the closed values
# carry the error outward; they are listed because the reading is what was
# measured, not because each adds something.
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
          1n
        case 1n+1n+q:
          1n + log2_go(p, P.half(1n + 1n + q))

def nat_log2(+n: Nat) -> Nat:
  log2_go(n, n)
