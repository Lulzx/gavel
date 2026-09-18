import Base
import ./prelude.bend as P

def mod5_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
