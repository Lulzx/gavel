import Base
import ./prelude.bend as P

# Mutant: the node case swaps its subtrees as it descends, so the answer is the
# old tree mirrored as well as inserted into. The leaf case is untouched, so the
# anchor law holds; the step law catches the swap, and the content law separates
# the two answers wherever the tree branches.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# tree_insert_node, tree_insert_flatten.
def tree_insert(t: P.Tree, v: Nat) -> P.Tree:
  match t:
    case P.Leaf{w}:
      P.Node{P.Leaf{v}, P.Leaf{w}}
    case P.Node{l, r}:
      P.Node{r, tree_insert(l, v)}
