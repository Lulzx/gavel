import Base
import ./prelude.bend as P

def has_mult5(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
