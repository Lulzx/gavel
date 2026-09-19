import Base
import ./prelude.bend as P

# The reference with the appended leaf carrying a constant instead of `v`. The
# shape is the reference's at every node, so `snoc_tree_leftmost` and
# `snoc_tree_right_spine` both hold, and only `snoc_tree_rightmost` notices
# that `v` was dropped.
#
# Measured 2026-09-19 under this task's own reference proof: tier 3, proving
# `snoc_tree_leftmost` and `snoc_tree_right_spine` and failing
# `snoc_tree_rightmost` (`expected : v / observed : 0n`).
def snoc_tree(t: P.Tree, v: Nat) -> P.Tree:
  match t:
    case P.Leaf{x}:
      P.Node{P.Leaf{x}, P.Leaf{0n}}
    case P.Node{l, r}:
      P.Node{l, snoc_tree(r, v)}
