import Base
import ./prelude.bend as P

def dec2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.dec2(h) <> dec2_all(t)
