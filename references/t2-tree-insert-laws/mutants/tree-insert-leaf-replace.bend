import Base
import ./prelude.bend as P

# Mutant: the leaf case answers the new leaf alone, overwriting the number that
# was there, so an insertion loses a number. Type-checks, and it is the anchor
# law that catches it: no tree of one leaf is a node of two.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# tree_insert_leaf, tree_insert_flatten.
def tree_insert(t: P.Tree, v: Nat) -> P.Tree:
  match t:
    case P.Leaf{w}:
      P.Leaf{v}
    case P.Node{l, r}:
      P.Node{tree_insert(l, v), r}
