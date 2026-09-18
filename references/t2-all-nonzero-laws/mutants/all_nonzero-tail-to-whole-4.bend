import Base
import ./prelude.bend as P

def all_nonzero(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      Bool.and(P.is_nonzero_b(h), all_nonzero(xs))
