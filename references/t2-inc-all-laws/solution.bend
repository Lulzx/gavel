import Base
import ./prelude.bend as P

def inc_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      (h + 1n) <> inc_all(t)
