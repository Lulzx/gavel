import Base
import ./prelude.bend as P

def triple_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      P.triple(h) <> triple_all(t)

    case h <> t:
      Nil{}
