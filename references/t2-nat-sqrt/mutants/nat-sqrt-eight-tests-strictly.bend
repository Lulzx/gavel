import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `nat_sqrt_eight`, and with it the gap between two squares.
# The next square is `k * k + 2k + 1`, and the fit is decided by testing that sum
# against `n`; this body leaves out the `1n` -- it tests `k * k + 2k`, the reading
# a policy that carried the ladder's `2k + 1` as `2k` has -- so it raises the
# answer one step early over the numbers between two squares: `8n` reads `3n`
# where the reference reads `2n`, since `4n + 4n` is exactly `8n`. It is otherwise
# the reference, and the exact squares are untouched: at `4n` and `9n` the next
# square is exactly `n` and the sum is not below it either way, so the answer is
# `2n` and `3n` as it should be. The generator cannot reach this answer: it
# rewrites what a step passes on, and this changes the arithmetic the step feeds
# the comparison.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i3.json check
# t2-nat-sqrt --solution <this file> --proof references/t2-nat-sqrt/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["nat_sqrt_succ",
# "nat_sqrt_mono", "nat_sqrt_eight"]`, and the checker's own words at the closed
# law are `expected : 3n` against `observed : 2n` -- this body's answer against
# the law's.
def nat_sqrt(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n++np:
      +k = nat_sqrt(np)
      Nat.add(k, P.le_ind(Nat.add(Nat.mul(k, k), Nat.add(k, k)), 1n + np))
