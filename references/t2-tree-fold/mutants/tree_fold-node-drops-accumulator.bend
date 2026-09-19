# `tree_fold` rebuilds the accumulator as the empty list at every node.
#
# The leaf case is the reference's and the recursion descends the same
# subtrees; only the accumulator the node hands down is thrown away. It is the
# law that says the accumulator is a suffix of the answer that catches it, and
# the law that says a node folds its subtrees with the accumulator it was given.
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
      tree_fold(l, tree_fold(r, Nil{}))
