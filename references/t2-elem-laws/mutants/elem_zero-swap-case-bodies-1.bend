import Base
import ./prelude.bend as P

def elem_zero(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      Bool.or(P.is_zero_b(h), elem_zero(t))

    case h <> t:
      False{}
