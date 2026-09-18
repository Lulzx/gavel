import Base
import ./prelude.bend as P

def prefixes(xs: List<&2, Nat>) -> P.Prefixes:
  match xs:
    case Nil{}:
      P.PCons{Nil{}, P.PNil{}}
    case h <> t:
      P.PCons{Nil{}, P.PNil{}}
