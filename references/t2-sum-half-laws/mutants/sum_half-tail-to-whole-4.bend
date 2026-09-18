import Base
import ./prelude.bend as P

def sum_half(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.half(h) + sum_half(xs)
