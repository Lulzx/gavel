import Base
import ./prelude.bend as P

def split(+xs: List<&2, Nat>) -> P.PairL:
  match xs:
    case Nil{}:
      P.MkL{Nil{}, Nil{}}
    case h <> t:
      P.MkL{h <> P.odds(split(t)), P.evens(split(t))}
