import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `nat_sqrt_four`, and with it every closed law. The decision
# is taken on the square of the *next* number against this `n`; this body takes it
# on the square of the answer so far -- "does the answer's own square still fit?"
# -- which is the reading a policy that asked the wrong question of the right
# numbers has, and which answers `1n` too much at almost every `n`: `4n` reads
# `3n` where the reference reads `2n`, and because the answer is already too big
# the error is carried up, so `8n` and `9n` part as well. It is otherwise the
# reference and the empty input is untouched. The generator cannot reach this
# answer: it rewrites what a step passes on, and this changes the term the
# comparison is made of, which is the step's own arithmetic.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i3.json check
# t2-nat-sqrt --solution <this file> --proof references/t2-nat-sqrt/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["nat_sqrt_succ",
# "nat_sqrt_mono", "nat_sqrt_four", "nat_sqrt_eight", "nat_sqrt_nine"]`, and the
# checker's own words at the closed laws are `expected : 3n` against `observed :
# 2n` at `4n` and `8n`, and `expected : 4n` against `observed : 3n` at `9n`.
def nat_sqrt(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n++np:
      +k = nat_sqrt(np)
      Nat.add(k, P.le_ind(Nat.mul(k, k), 1n + np))
