import Base
import ./prelude.bend as P

def tree_leaf_count(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      1n
    case P.Node{l, r}:
      tree_leaf_count(l) + tree_leaf_count(t)
