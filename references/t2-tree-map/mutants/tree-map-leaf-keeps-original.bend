import Base
import ./prelude.bend as P

# The reference with the leaf case answering the leaf it was given: the map
# does nothing where the recursion stops, and the tree it produces keeps the
# original values. The shape is untouched, so `tree_map_leaves` still holds.
#
# Measured 2026-09-19 under this task's own reference proof: tier 3, failing
# `tree_map_leftmost` and `tree_map_rightmost` (`expected : 1n + v / observed :
# v`). `tree_map_leaves` holds, because the shape of the tree is untouched.
def tree_map(t: P.Tree) -> P.Tree:
  match t:
    case P.Leaf{v}:
      P.Leaf{v}
    case P.Node{l, r}:
      P.Node{tree_map(l), tree_map(r)}
