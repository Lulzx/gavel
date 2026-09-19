import Base
import ./prelude.bend as P

# Mutant: the node case descends into the right subtree, so the new number goes
# in at the rightmost leaf instead. The leaf case is untouched, so the anchor
# law holds; the step law catches the side, and the content law catches the
# position the number ends up in.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# tree_insert_node, tree_insert_flatten.
def tree_insert(t: P.Tree, v: Nat) -> P.Tree:
  match t:
    case P.Leaf{w}:
      P.Node{P.Leaf{v}, P.Leaf{w}}
    case P.Node{l, r}:
      P.Node{l, tree_insert(r, v)}
