import Base
import ./prelude.bend as P

def tree_max(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      P.max(tree_max(l), tree_max(r))

    case P.Node{l, r}:
      v
