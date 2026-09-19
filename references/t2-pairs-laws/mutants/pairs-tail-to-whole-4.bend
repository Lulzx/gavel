import Base
import ./prelude.bend as P

def pairs(xs: List<Nat>) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      Nil{}
    case x <> t:
      match xs:
        case Nil{}:
          Nil{}
        case +h <> t2:
          P.MkPair{x, h} <> pairs(h <> t2)
