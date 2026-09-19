import Base
import ./prelude.bend as P

def tree_map(t: P.Tree) -> P.Tree:
  match t:
    case P.Leaf{v}:
      P.Leaf{P.inc(v)}
    case P.Node{l, r}:
      P.Node{tree_map(l), tree_map(r)}
