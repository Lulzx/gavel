import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `path_sum_zeroed`, and the leaf anchor with it. A leaf
# answers the value it carries; this body answers `1n` there instead -- a leaf
# counted rather than weighed, which is the body that satisfies the two closed
# laws' *shape* reading while putting a different number on every leaf. It is
# the only hand mutant that separates `path_sum_zeroed`: every other wrong body
# in this corpus drops values, and a dropped value is still zero on a tree whose
# values are all zero, but a constant added per leaf is not.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.h2.json check
# t2-path-sum --solution <this file> --proof references/t2-path-sum/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["path_sum_leaf",
# "path_sum_three", "path_sum_deep", "path_sum_zeroed"]`. Four laws, and the
# node law survives -- the step is untouched, so the body is only wrong about
# what sits at the bottom of the walk.
def path_sum(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      1n
    case P.Node{+l, key, +r}:
      Nat.add(Nat.add(path_sum(l), path_sum(r)), Nat.mul(key, Nat.add(P.leaves(l), P.leaves(r))))
