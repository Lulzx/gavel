import Base
import ./prelude.bend as P

def count_odd(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.is_odd(h) + count_odd(xs)
