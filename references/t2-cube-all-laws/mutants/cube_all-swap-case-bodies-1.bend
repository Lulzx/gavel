import Base
import ./prelude.bend as P

def cube_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      P.cube(h) <> cube_all(t)

    case h <> t:
      Nil{}
