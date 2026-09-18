import Base
import ./prelude.bend as P

def tree_sum(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{}:
      tree_sum(l) + key + tree_sum(r)

    case P.Node{l, key, r}:
      0n
