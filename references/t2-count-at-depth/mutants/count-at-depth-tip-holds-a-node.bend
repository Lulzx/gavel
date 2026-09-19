import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `count_at_depth_tip`. A tip is the empty tree and holds
# no node at any depth, so the answer is `0n`; this body answers `1n` -- the
# reading a policy that treats an empty tree as a leaf has. It is otherwise the
# reference. No other law reaches a tip: the step law is stated at a bin, the
# depth-zero law reaches a tip only at depth `0n` where this body still answers
# `1n`, and the closed law is bins to depth `1n` and never looks at what a tip
# holds. The generator cannot reach this answer at all -- its rewrites change
# what a step passes on, and this is the branch a step never reaches -- which is
# why the law would otherwise have no kill.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i3.json check
# t2-count-at-depth --solution <this file> --proof references/t2-count-at-depth/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["count_at_depth_tip",
# "count_at_depth_zero"]`, and the checker's own words at the depth-zero law are
# `expected : 1n` against `observed : 0n` -- a tip answers a node there too.
def count_at_depth(t: P.Tree, d: Nat) -> Nat:
  match t:
    case P.Tip{}:
      1n
    case P.Bin{l, key, r}:
      match d:
        case 0n:
          1n
        case 1n++dp:
          count_at_depth(l, dp) + count_at_depth(r, dp)
