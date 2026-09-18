import Base
import ./prelude.bend as P

def succ2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      P.succ2(h) <> succ2_all(t)

    case h <> t:
      Nil{}
