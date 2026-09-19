# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g3.json check
# t2-count-divisors --solution
# references/t2-count-divisors/mutants/count-divisors-handoff-shortens-the-walk.bend
# --proof references/t2-count-divisors/PROOF.bend --backend plain --json`:
# **tier 3**, laws_failed = [count_divisors_handoff]. The walk starts at half of
# `n` and adds `1n` for `n` itself, which happens to give the right count: every
# closed value below still agrees. `count_divisors_handoff` is the only law that
# sees it, because it is the law that pins where the walk starts rather than
# what it answers -- a decomposition `==` law, not a value law. Recorded here
# because it is the sole measurement of that pin: the generated strong mutants
# all leave `count_divisors` unfolding to `cd_go(n, n)`.
import Base
import ./prelude.bend as P

def cd_go(+n: Nat, +k: Nat) -> Nat:
  match k:
    case 0n:
      0n
    case 1n+kp:
      Bool.pick(Nat, P.divides(n, k), 1n, 0n) + cd_go(n, kp)

def count_divisors(+n: Nat) -> Nat:
  cd_go(n, Nat.div(n, 2n)) + 1n
