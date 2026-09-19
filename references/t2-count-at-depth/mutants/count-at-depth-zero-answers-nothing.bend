import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `count_at_depth_zero`. The root of a bin is a node, so at
# depth `0n` the answer is `1n`; this body answers `0n` -- the reading a policy
# that counts a node only once it has descended into a subtree has. It is
# otherwise the reference, so the step law (stated at `1n + d`, which never
# reaches depth zero) is untouched and the closed law is reached below the root.
# The generator cannot reach this answer: it rewrites what a step passes on, and
# this is the depth a step has already left behind.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i3.json check
# t2-count-at-depth --solution <this file> --proof references/t2-count-at-depth/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["count_at_depth_zero",
# "count_at_depth_three"]`, and the checker's own words at the closed law are
# `expected : 0n` against `observed : 2n` -- the root contributes nothing, so the
# level below the root reads one short.
def count_at_depth(t: P.Tree, d: Nat) -> Nat:
  match t:
    case P.Tip{}:
      0n
    case P.Bin{l, key, r}:
      match d:
        case 0n:
          0n
        case 1n++dp:
          count_at_depth(l, dp) + count_at_depth(r, dp)
