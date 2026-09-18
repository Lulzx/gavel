import Base
import ./prelude.bend as P

def all_one(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      Bool.and(P.is_one_b(h), all_one(t))

    case h <> t:
      True{}
