import Base
import ./prelude.bend as P

def mod3_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      P.mod3(h) <> mod3_all(t)

    case h <> t:
      Nil{}
