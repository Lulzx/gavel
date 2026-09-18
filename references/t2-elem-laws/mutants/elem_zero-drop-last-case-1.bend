import Base
import ./prelude.bend as P

def elem_zero(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
