import Base
import ./prelude.bend as P

def min_first(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      P.mf_put(h, min_first(t))

    case h <> t:
      Nil{}
