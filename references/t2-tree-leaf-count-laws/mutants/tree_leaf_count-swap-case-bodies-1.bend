import Base
import ./prelude.bend as P

def tree_leaf_count(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      tree_leaf_count(l) + tree_leaf_count(r)

    case P.Node{l, r}:
      1n
