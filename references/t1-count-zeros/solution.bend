import Base
import ./prelude.bend as P

def count_zeros(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.is_zero(h) + count_zeros(t)
