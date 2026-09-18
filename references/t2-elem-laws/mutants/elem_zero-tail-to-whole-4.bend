import Base
import ./prelude.bend as P

def elem_zero(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      Bool.or(P.is_zero_b(h), elem_zero(xs))
