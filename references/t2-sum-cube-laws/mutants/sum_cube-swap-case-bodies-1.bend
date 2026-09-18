import Base
import ./prelude.bend as P

def sum_cube(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      P.cube(h) + sum_cube(t)

    case h <> t:
      0n
