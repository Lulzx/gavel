import Base
import ./prelude.bend as P

def all_zero(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
