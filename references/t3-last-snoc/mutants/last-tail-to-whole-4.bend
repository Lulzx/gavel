import Base
import ./prelude.bend as P

def last(xs: List<&2, Nat>, d: Nat) -> Nat:
  match xs:
    case Nil{}:
      d
    case h <> t:
      last(xs, h)
