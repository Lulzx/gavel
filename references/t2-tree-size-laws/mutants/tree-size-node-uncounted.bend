import Base
import ./prelude.bend as P

# Hand-authored: the node's own contribution is dropped, so the answer counts
# the leaves only. This is the near miss the third law is stated in terms of:
# `P.nodes` lists one entry per node, so a leaf-only count comes out short.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing `tree_size_node`, `tree_size_nodes`
def tree_size(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      1n
    case P.Node{l, key, r}:
      tree_size(l) + tree_size(r)
