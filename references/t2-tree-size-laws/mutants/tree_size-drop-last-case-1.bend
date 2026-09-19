import Base
import ./prelude.bend as P

def tree_size(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      1n
