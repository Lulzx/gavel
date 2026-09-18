import Base
import ./prelude.bend as P

def flatten(t: P.Tree) -> List<&2, Nat>:
  match t:
    case P.Leaf{v}:
      v <> Nil{}
    case P.Node{l, r}:
      Nil{}
