import Base
import ./prelude.bend as P

def sq_inc_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.sq_inc(h) <> sq_inc_all(xs)
