import Base
import ./prelude.bend as P

def reverse(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      P.append(reverse(t), h <> Nil{})

    case h <> t:
      Nil{}
