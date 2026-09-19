# `tree_fold` folds the left subtree first and hands the result to the right.
#
# The recursion is the reference's in shape and the leaf case is untouched; the
# two subtree calls are exchanged. The fold is still a fold and the answer is
# still a permutation of the same leaves, which is why the swap has to be
# caught by the law that states the order rather than by a count.
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
      tree_fold(r, tree_fold(l, acc))
