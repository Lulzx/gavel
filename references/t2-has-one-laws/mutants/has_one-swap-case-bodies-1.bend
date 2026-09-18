import Base
import ./prelude.bend as P

def has_one(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      Bool.or(P.is_one_b(h), has_one(t))

    case h <> t:
      False{}
