import Base
import ./prelude.bend as P

def mod5_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      P.mod5(h) <> mod5_all(t)

    case h <> t:
      Nil{}
