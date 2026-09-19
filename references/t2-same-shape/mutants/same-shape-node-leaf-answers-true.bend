import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `same_shape_node_leaf`. A node over a leaf is not the
# same shape either, so the walk answers `False{}` there; this body answers
# `True{}` instead. It is the answer of the match's third case, which the
# generator's rules do not rewrite, and it is the law that separates a body
# wrong in one direction only -- the leaf/node law is a different call.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.h2.json check
# t2-same-shape --solution <this file> --proof
# references/t2-same-shape/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["same_shape_node_leaf"]`. Exactly the law for this pair, and
# not `same_shape_leaf_node`, which is the other call.
def same_shape(t1: P.Tree, t2: P.Tree) -> Bool:
  match t1 t2:
    case P.Leaf{v} P.Leaf{w}:
      True{}
    case P.Leaf{v} P.Node{l, key, r}:
      False{}
    case P.Node{l, key, r} P.Leaf{w}:
      True{}
    case P.Node{l1, key1, r1} P.Node{l2, key2, r2}:
      Bool.and(same_shape(l1, l2), same_shape(r1, r2))
