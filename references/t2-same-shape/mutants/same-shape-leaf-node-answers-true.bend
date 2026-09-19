import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `same_shape_leaf_node`. A leaf and a node are not the
# same shape, so the walk answers `False{}` when its first argument is a leaf
# and its second a node; this body answers `True{}` there instead. It is the
# answer of the match's second case, which the generator's rules do not rewrite,
# and `same_shape_node_leaf` is a different call: a body wrong in this direction
# only is caught here and nowhere else.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.h2.json check
# t2-same-shape --solution <this file> --proof
# references/t2-same-shape/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["same_shape_leaf_node"]`. It is the only law that reaches this
# pair, so the kill is exactly this one.
def same_shape(t1: P.Tree, t2: P.Tree) -> Bool:
  match t1 t2:
    case P.Leaf{v} P.Leaf{w}:
      True{}
    case P.Leaf{v} P.Node{l, key, r}:
      True{}
    case P.Node{l, key, r} P.Leaf{w}:
      False{}
    case P.Node{l1, key1, r1} P.Node{l2, key2, r2}:
      Bool.and(same_shape(l1, l2), same_shape(r1, r2))
