import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `path_sum_leaf`. A leaf is the end of its own path and
# answers the value it carries, so the walk's leaf case is `v`; this body
# answers `0n` there instead -- the reading that says a leaf contributes only
# the keys above it. It is an answer the match has already stopped to give, so
# no recursive-step rewrite reaches it: the generated corpus never exercises
# this law, and neither closed law can be satisfied by a body that gets the leaf
# case wrong.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.h2.json check
# t2-path-sum --solution <this file> --proof references/t2-path-sum/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["path_sum_leaf",
# "path_sum_three", "path_sum_deep"]`. Both closed laws go with the anchor,
# since a zero at every leaf drops exactly the leaves' share of their answers.
def path_sum(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      0n
    case P.Node{+l, key, +r}:
      Nat.add(Nat.add(path_sum(l), path_sum(r)), Nat.mul(key, Nat.add(P.leaves(l), P.leaves(r))))
