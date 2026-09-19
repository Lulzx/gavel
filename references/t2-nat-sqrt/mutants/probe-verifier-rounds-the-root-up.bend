import Base
import ./prelude.bend as P

# PROBE. An independently invented body that reads `nat_sqrt` as the square root
# rounded *up* rather than down -- the smallest `k` with `k * k` at least `n`,
# which is the reading a policy that took "the square root" for the ceiling rather
# than the floor has. It is the same ladder as the reference with the comparison
# moved: the next square is asked to be strictly above what fits, so the answer
# rises one step early over every gap between two squares -- `8n` reads `3n`, and
# `1n` reads `1n` where the reference also reads `1n`. It agrees with the
# reference at `0n`, `4n` and `9n`, which is the point: a law set that read only
# the exact squares would pay this body, and a reading of the laws that pays it is
# a hole. It is a body from a different reading rather than a reordered one, so
# the generated corpus does not contain it.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i3.json check
# t2-nat-sqrt --solution <this file> --proof references/t2-nat-sqrt/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["nat_sqrt_succ",
# "nat_sqrt_mono", "nat_sqrt_eight"]`, and the checker's own words at the closed
# law are `expected : 3n` against `observed : 2n` -- this body's answer against
# the law's, which is the ceiling at `8n`.
def nat_sqrt(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n++np:
      +k = nat_sqrt(np)
      Nat.add(k, P.le_ind(Nat.add(1n, Nat.mul(k, k)), 1n + np))
