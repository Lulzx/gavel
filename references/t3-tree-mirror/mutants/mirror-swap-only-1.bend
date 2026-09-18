import Base
import ./prelude.bend as P

def mirror(t: P.Tree) -> P.Tree:
  match t:
    case P.Leaf{v}:
      P.Leaf{v}
    case P.Node{l, r}:
      P.Node{r, l}
