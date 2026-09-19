import Base
import ./prelude.bend as P

# Mutant: the node case descends the left subtree only, so the right subtree's
# leaves are never read. The leaf case is untouched, so the anchor law holds;
# the step law catches it on any tree whose subtrees differ.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# tree_leaf_count_node, tree_leaf_count_flatten.
def tree_leaf_count(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      1n
    case P.Node{l, r}:
      tree_leaf_count(l)
