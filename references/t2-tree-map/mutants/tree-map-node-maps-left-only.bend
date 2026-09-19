import Base
import ./prelude.bend as P

# The reference with the right subtree of every node handed back untouched. The
# left spine is still mapped, so `tree_map_leftmost` holds; the right spine is
# not, so `tree_map_rightmost` fails, and the leaves under every right subtree
# are uncounted, so `tree_map_leaves` fails too.
#
# Measured 2026-09-19 under this task's own reference proof: tier 3, failing
# `tree_map_rightmost` and `tree_map_leaves`. `tree_map_leftmost` holds,
# because the left spine is still mapped.
def tree_map(t: P.Tree) -> P.Tree:
  match t:
    case P.Leaf{v}:
      P.Leaf{P.inc(v)}
    case P.Node{l, r}:
      P.Node{tree_map(l), r}
