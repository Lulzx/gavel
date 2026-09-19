import Base
import ./prelude.bend as P

# Mutant: the node case answers the node it was given, so nothing is inserted
# below the root. The leaf case is untouched, so the anchor law holds and every
# tree with a single leaf is right; the step law catches it on any node.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# tree_insert_node, tree_insert_flatten.
def tree_insert(t: P.Tree, v: Nat) -> P.Tree:
  match t:
    case P.Leaf{w}:
      P.Node{P.Leaf{v}, P.Leaf{w}}
    case P.Node{l, r}:
      P.Node{l, r}
