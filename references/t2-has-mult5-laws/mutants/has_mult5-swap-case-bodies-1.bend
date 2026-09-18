import Base
import ./prelude.bend as P

def has_mult5(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      Bool.or(P.is_mult5_b(h), has_mult5(t))

    case h <> t:
      False{}
