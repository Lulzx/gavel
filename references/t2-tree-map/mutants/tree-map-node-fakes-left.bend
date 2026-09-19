import Base
import ./prelude.bend as P

# The reference with the left subtree of every node thrown away and a fixed
# leaf put in its place. The recursion still walks the right spine, so
# `tree_map_rightmost` holds; the leftmost leaf is now always `0n`, and every
# leaf under a left subtree is gone.
#
# Measured 2026-09-19 under this task's own reference proof: tier 3, failing
# `tree_map_leftmost` and `tree_map_leaves`.
def tree_map(t: P.Tree) -> P.Tree:
  match t:
    case P.Leaf{v}:
      P.Leaf{P.inc(v)}
    case P.Node{l, r}:
      P.Node{P.Leaf{0n}, tree_map(r)}
