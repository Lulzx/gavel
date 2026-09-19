# `tree_fold` answers a leaf with the leaf alone and forgets the accumulator.
#
# This file exists for the leaf case, which is the case a fold stops at: the
# generator rewrites steps, and this is the answer the stopped match gives. It
# type-checks, and the recursion is the reference's everywhere above the leaf.
#
# Measured 2026-09-19 against this task's law set: tier 3, proving
# `tree_fold_node` and failing `tree_fold_leaf`, `tree_fold_flatten`.
import Base
import ./prelude.bend as P

def tree_fold(t: P.Tree, acc: List<&2, Nat>) -> List<&2, Nat>:
  match t:
    case P.Leaf{v}:
      v <> Nil{}
    case P.Node{l, r}:
      tree_fold(l, tree_fold(r, acc))
