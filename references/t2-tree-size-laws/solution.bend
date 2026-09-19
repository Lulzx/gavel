import Base
import ./prelude.bend as P

def tree_size(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      1n
    case P.Node{l, key, r}:
      1n + tree_size(l) + tree_size(r)
