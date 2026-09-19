import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `nat_sqrt_zero`. Nothing below `1n` has a square under it,
# so the answer at `0n` is `0n`; this body answers `1n` -- the reading a policy
# that counted the step it was standing on rather than the squares it had fitted
# has, and the reading that would follow from starting the ladder at `1n` instead
# of at `0n`. It is otherwise the reference, and every other law is untouched: the
# step law is stated at `1n + n`, so it never reaches this branch, and `4n`, `8n`
# and `9n` are reached from above, where one extra unit at the bottom is absorbed
# (at `4n` this body still answers `2n`). Only the empty input reaches this branch,
# which is why the law is a pin and why the generator cannot reach the answer: its
# rewrites change what a step passes on, and this is the case above every step.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i3.json check
# t2-nat-sqrt --solution <this file> --proof references/t2-nat-sqrt/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["nat_sqrt_zero"]`.
def nat_sqrt(n: Nat) -> Nat:
  match n:
    case 0n:
      1n
    case 1n++np:
      +k = nat_sqrt(np)
      Nat.add(k, P.le_ind(Nat.mul(1n + k, 1n + k), 1n + np))
