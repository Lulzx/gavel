import Base
import ./prelude.bend as P

def tree_sum(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{}:
      0n
    case P.Node{l, key, r}:
      tree_sum(t) + key + tree_sum(r)
