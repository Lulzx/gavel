import Base
import ./prelude.bend as P

def sum_half(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      P.half(h) + sum_half(t)

    case h <> t:
      0n
