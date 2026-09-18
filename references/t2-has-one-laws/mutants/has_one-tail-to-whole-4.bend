import Base
import ./prelude.bend as P

def has_one(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      Bool.or(P.is_one_b(h), has_one(xs))
