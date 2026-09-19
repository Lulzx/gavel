import Base
import ./prelude.bend as P

# Hand-authored: the base case only. The leaf answers its own value instead of
# counting itself, so the answer is a number the tree carries rather than the
# number of nodes.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing `tree_size_leaf`, `tree_size_nodes`
def tree_size(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      v
    case P.Node{l, key, r}:
      1n + tree_size(l) + tree_size(r)
