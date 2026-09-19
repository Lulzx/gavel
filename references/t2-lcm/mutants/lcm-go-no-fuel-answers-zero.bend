# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g3.json check
# t2-lcm --solution
# references/t2-lcm/mutants/lcm-go-no-fuel-answers-zero.bend --proof
# references/t2-lcm/PROOF.bend --backend plain --json`: **tier 3**,
# laws_failed = [lcm_go_no_fuel]. The walk's give-up arm answers `0n` instead of
# the candidate it reached. No closed value reaches it: every pair here finds
# its multiple with budget to spare, `lcm_five_seven` included, which spends the
# budget exactly and so stops on its last candidate rather than past it.
# Recorded here because it is the only measurement of `lcm_go_no_fuel`.
import Base
import ./prelude.bend as P

def lcm_go(fuel: Nat, +c: Nat, +step: Nat, +m: Nat) -> Nat:
  match fuel:
    case 0n:
      0n
    case 1n++f:
      Bool.pick(Nat, P.divides(c, m), c, lcm_go(f, c + step, step, m))

def lcm(+n: Nat, +m: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n++p:
      match m:
        case 0n:
          0n
        case 1n++q:
          lcm_go(1n + q, 1n + p, 1n + p, 1n + q)
