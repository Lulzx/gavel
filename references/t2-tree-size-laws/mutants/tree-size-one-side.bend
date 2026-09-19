import Base
import ./prelude.bend as P

# Hand-authored: the node descends its left subtree only, so the answer ignores
# everything hanging off a right spine. It agrees with the reference on any
# tree whose right subtrees are leaves and nowhere else.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing `tree_size_node`, `tree_size_nodes`
def tree_size(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      1n
    case P.Node{l, key, r}:
      1n + tree_size(l)
