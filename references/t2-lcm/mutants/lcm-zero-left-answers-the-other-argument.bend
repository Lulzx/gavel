# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g3.json check
# t2-lcm --solution
# references/t2-lcm/mutants/lcm-zero-left-answers-the-other-argument.bend --proof
# references/t2-lcm/PROOF.bend --backend plain --json`: **tier 3**,
# laws_failed = [lcm_zero_left]. The outer empty arm answers `m` instead of
# `0n`. `lcm_zero_right` still holds: at `n = 0n` the two arms agree, and above
# zero the inner arm decides, so only the law that names the left argument sees
# this. Recorded here because it is the only measurement of `lcm_zero_left`.
import Base
import ./prelude.bend as P

def lcm_go(fuel: Nat, +c: Nat, +step: Nat, +m: Nat) -> Nat:
  match fuel:
    case 0n:
      c
    case 1n++f:
      Bool.pick(Nat, P.divides(c, m), c, lcm_go(f, c + step, step, m))

def lcm(+n: Nat, +m: Nat) -> Nat:
  match n:
    case 0n:
      m
    case 1n++p:
      match m:
        case 0n:
          0n
        case 1n++q:
          lcm_go(1n + q, 1n + p, 1n + p, 1n + q)
