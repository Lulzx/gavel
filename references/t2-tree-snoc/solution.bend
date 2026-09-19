import Base
import ./prelude.bend as P

def snoc_tree(t: P.Tree, v: Nat) -> P.Tree:
  match t:
    case P.Leaf{x}:
      P.Node{P.Leaf{x}, P.Leaf{v}}
    case P.Node{l, r}:
      P.Node{l, snoc_tree(r, v)}
