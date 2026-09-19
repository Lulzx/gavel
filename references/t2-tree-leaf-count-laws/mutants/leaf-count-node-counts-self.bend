import Base
import ./prelude.bend as P

# Mutant: every interior node adds `1n` for itself, so the reading counts the
# nodes rather than the leaves. The leaf case is untouched, so the anchor law
# holds; the step law catches it, one more than the two subtrees on every input
# with a node.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# tree_leaf_count_node, tree_leaf_count_flatten.
def tree_leaf_count(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      1n
    case P.Node{l, r}:
      1n + tree_leaf_count(l) + tree_leaf_count(r)
