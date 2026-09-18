import Base
import ./prelude.bend as P

def sum_dec2(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.dec2(h) + sum_dec2(xs)
