import Base
import ./prelude.bend as P

def triple_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.triple(h) <> triple_all(t)
