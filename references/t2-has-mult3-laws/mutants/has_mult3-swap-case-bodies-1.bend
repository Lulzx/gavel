import Base
import ./prelude.bend as P

def has_mult3(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      Bool.or(P.is_mult3_b(h), has_mult3(t))

    case h <> t:
      False{}
