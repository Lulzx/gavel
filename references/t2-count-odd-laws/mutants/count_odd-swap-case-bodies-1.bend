import Base
import ./prelude.bend as P

def count_odd(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      P.is_odd(h) + count_odd(t)

    case h <> t:
      0n
