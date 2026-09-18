import Base
import ./prelude.bend as P

def pow2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.pow2(h) <> pow2_all(t)
