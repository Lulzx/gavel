import Base
import ./prelude.bend as P

# PROBE. An independently invented body that reads "how many nodes sit at depth
# d" as "how many sit at depth d or above": it counts the node in hand and then
# everything its subtrees hold below, so on the closed tree of the last law it
# answers `3n` at depth `1n` (the root plus the two children) where the reference
# answers `2n`. It is a plausible reading -- a policy that thought the count was
# a running total rather than a level -- and it must be caught: a reading of the
# laws that pays this body is a hole.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i3.json check
# t2-count-at-depth --solution <this file> --proof references/t2-count-at-depth/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["count_at_depth_step",
# "count_at_depth_three"]`, and the checker's own words at the closed law are
# `expected : 2n` against `observed : 3n` -- the running total reads one extra at
# every level below the root, which is what the step law is here to refuse.
def count_at_depth(t: P.Tree, d: Nat) -> Nat:
  match t:
    case P.Tip{}:
      0n
    case P.Bin{l, key, r}:
      match d:
        case 0n:
          1n
        case 1n++dp:
          1n + (count_at_depth(l, dp) + count_at_depth(r, dp))
