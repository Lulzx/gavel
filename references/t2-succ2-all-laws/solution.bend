import Base
import ./prelude.bend as P

def succ2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.succ2(h) <> succ2_all(t)
