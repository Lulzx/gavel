import Base
import ./prelude.bend as P

def height(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{}:
      0n
