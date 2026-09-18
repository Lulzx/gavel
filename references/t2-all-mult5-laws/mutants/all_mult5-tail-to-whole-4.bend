import Base
import ./prelude.bend as P

def all_mult5(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      Bool.and(P.is_mult5_b(h), all_mult5(xs))
