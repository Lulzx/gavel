import Base
import ./prelude.bend as P

def sum_dec2(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      P.dec2(h) + sum_dec2(t)

    case h <> t:
      0n
