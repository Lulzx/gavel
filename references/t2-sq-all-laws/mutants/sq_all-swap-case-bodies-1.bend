import Base
import ./prelude.bend as P

def sq_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      P.sq(h) <> sq_all(t)

    case h <> t:
      Nil{}
