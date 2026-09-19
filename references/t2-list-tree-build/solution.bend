import Base
import ./prelude.bend as P

def build(bs: List<&2, Nat>) -> P.Tree:
  match bs:
    case Nil{}:
      P.Leaf{0n}
    case h <> t:
      P.Node{P.Leaf{h}, build(t)}
