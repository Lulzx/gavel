import Base
import ./prelude.bend as P

# The reference with the recursion sent down the left spine instead of the
# right one. The leftmost leaf of the answer is still the leftmost leaf of the
# input, so `snoc_tree_leftmost` holds; the new leaf ends up at the bottom of
# the left spine, so `snoc_tree_rightmost` does not, and the right spine does
# not grow at all, which is `snoc_tree_right_spine`'s failure.
#
# Measured 2026-09-19 under this task's own reference proof: tier 2, proving no
# law at all. The leaf case puts `v` at the leftmost leaf of a leaf, which
# contradicts `snoc_tree_leftmost` before the spine laws are reached.
def snoc_tree(t: P.Tree, v: Nat) -> P.Tree:
  match t:
    case P.Leaf{x}:
      P.Node{P.Leaf{v}, P.Leaf{x}}
    case P.Node{l, r}:
      P.Node{snoc_tree(l, v), r}
