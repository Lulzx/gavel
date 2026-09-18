import Base
import ./prelude.bend as P

def sum_cube(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
