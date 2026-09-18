import Base
import ./prelude.bend as P

def all_zero(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      Bool.and(P.is_zero_b(h), all_zero(t))

    case h <> t:
      True{}
