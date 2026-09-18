import Base
import ./prelude.bend as P

def height(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{}:
      0n
    case P.Node{l, r}:
      1n + P.max(height(l), height(r))
