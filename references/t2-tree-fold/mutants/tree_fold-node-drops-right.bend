# `tree_fold` folds only the left subtree of a node.
#
# The leaf case is the reference's and the accumulator is passed through
# unchanged; the right subtree is never read. It type-checks, and it is what the
# node law and the law that the answer carries every leaf reject.
#
# Measured 2026-09-19 against this task's law set: tier 3, proving
# `tree_fold_leaf` and failing `tree_fold_node`, `tree_fold_flatten`.
import Base
import ./prelude.bend as P

def tree_fold(t: P.Tree, acc: List<&2, Nat>) -> List<&2, Nat>:
  match t:
    case P.Leaf{v}:
      v <> acc
    case P.Node{l, r}:
      tree_fold(l, acc)
