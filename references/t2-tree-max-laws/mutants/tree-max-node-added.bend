import Base
import ./prelude.bend as P

# Mutant: the node case adds the two subtree answers instead of taking the
# larger, so the reading is the tree's total. The leaf case is untouched, so the
# anchor law holds; the step law catches it, and the content law separates it
# from the sum in `P.max_all` as well.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# tree_max_node, tree_max_flatten.
def tree_max(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      v
    case P.Node{l, r}:
      tree_max(l) + tree_max(r)
