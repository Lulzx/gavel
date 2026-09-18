import Base
import ./prelude.bend as P

def all_nonzero(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
