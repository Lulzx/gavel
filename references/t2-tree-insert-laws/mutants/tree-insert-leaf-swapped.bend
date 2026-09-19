import Base
import ./prelude.bend as P

# Mutant: the leaf case builds the two children the other way round, so the new
# number lands to the right of the old one. Type-checks, and it is the anchor
# law that catches it -- the step law is stated at `P.Node{l, r}` and never
# reaches a leaf -- and the content law catches the order too.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# tree_insert_leaf, tree_insert_flatten.
def tree_insert(t: P.Tree, v: Nat) -> P.Tree:
  match t:
    case P.Leaf{w}:
      P.Node{P.Leaf{w}, P.Leaf{v}}
    case P.Node{l, r}:
      P.Node{tree_insert(l, v), r}
