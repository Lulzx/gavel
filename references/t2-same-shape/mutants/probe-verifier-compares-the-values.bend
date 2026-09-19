import Base
import ./prelude.bend as P

# PROBE. The plausible wrong answer: a body that compares the values as well as
# the shapes -- a leaf pair answers whether their values are equal, and a node
# pair requires the keys to be equal as well as both pairs of subtrees. It is
# the reading a policy that missed the word "ignoring" would write, and it is
# the body the six laws exist to separate. Read the verdict: **tier 3** means
# the law set catches it; tier 4 means the task pays full reward for it and the
# law set has a hole.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.h2.json check
# t2-same-shape --solution <this file> --proof
# references/t2-same-shape/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["same_shape_leaf_leaf", "same_shape_node_node",
# "same_shape_relabel", "same_shape_self"]`. No hole: the two value laws are
# the ones that exist to catch it, and `same_shape_relabel` is the one it fails
# at every level of the tree rather than only at a leaf.
def same_shape(t1: P.Tree, t2: P.Tree) -> Bool:
  match t1 t2:
    case P.Leaf{v} P.Leaf{w}:
      Nat.is_eq(v, w)
    case P.Leaf{v} P.Node{l, key, r}:
      False{}
    case P.Node{l, key, r} P.Leaf{w}:
      False{}
    case P.Node{l1, key1, r1} P.Node{l2, key2, r2}:
      Bool.and(Nat.is_eq(key1, key2), Bool.and(same_shape(l1, l2), same_shape(r1, r2)))
