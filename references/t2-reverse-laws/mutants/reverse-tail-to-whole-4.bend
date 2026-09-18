import Base
import ./prelude.bend as P

def reverse(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.append(reverse(xs), h <> Nil{})
