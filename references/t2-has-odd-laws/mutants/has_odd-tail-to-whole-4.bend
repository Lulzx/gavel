import Base
import ./prelude.bend as P

def has_odd(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      Bool.or(P.is_odd_b(h), has_odd(xs))
