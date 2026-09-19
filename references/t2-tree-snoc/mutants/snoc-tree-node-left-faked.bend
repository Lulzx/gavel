import Base
import ./prelude.bend as P

# The reference with the left subtree of every node thrown away and a fixed
# leaf put in its place. The recursion still walks the right spine, so
# `snoc_tree_rightmost` holds and the right spine still grows by one, so
# `snoc_tree_right_spine` holds too; the leftmost leaf is now always `0n`.
#
# Measured 2026-09-19 under this task's own reference proof: tier 3, proving
# `snoc_tree_rightmost` and `snoc_tree_right_spine` and failing
# `snoc_tree_leftmost` (`expected : leftmost(l) / observed : 0n`).
def snoc_tree(t: P.Tree, v: Nat) -> P.Tree:
  match t:
    case P.Leaf{x}:
      P.Node{P.Leaf{x}, P.Leaf{v}}
    case P.Node{l, r}:
      P.Node{P.Leaf{0n}, snoc_tree(r, v)}
