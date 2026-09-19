import Base
import ./prelude.bend as P

# The reference with the two subtrees of every node swapped: `inc` is applied
# at every leaf and no leaf is dropped or duplicated, so the tree has the same
# multiset of leaves as the reference's.
#
# Measured 2026-09-19 under this task's own reference proof: tier 2, failing
# `tree_map_leftmost`, `tree_map_rightmost` and `tree_map_leaves`. The answer
# differs from the reference on every tree whose two halves are not already
# equal, and the checker stops at `expected : l / observed : r`.
def tree_map(t: P.Tree) -> P.Tree:
  match t:
    case P.Leaf{v}:
      P.Leaf{P.inc(v)}
    case P.Node{l, r}:
      P.Node{tree_map(r), tree_map(l)}
