import Base
import ./prelude.bend as P

def cube_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.cube(h) <> cube_all(xs)
