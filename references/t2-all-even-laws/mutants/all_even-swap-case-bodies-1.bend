import Base
import ./prelude.bend as P

def all_even(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      Bool.and(P.is_even_b(h), all_even(t))

    case h <> t:
      True{}
