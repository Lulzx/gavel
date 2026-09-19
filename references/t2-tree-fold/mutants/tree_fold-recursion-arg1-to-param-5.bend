import Base
import ./prelude.bend as P

def tree_fold(t: P.Tree, acc: List<&2, Nat>) -> List<&2, Nat>:
  match t:
    case P.Leaf{v}:
      v <> acc
    case P.Node{l, r}:
      tree_fold(l, tree_fold(r, t))
