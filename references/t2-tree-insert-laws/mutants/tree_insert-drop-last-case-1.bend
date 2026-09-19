import Base
import ./prelude.bend as P

def tree_insert(t: P.Tree, v: Nat) -> P.Tree:
  match t:
    case P.Leaf{w}:
      P.Node{P.Leaf{v}, P.Leaf{w}}
