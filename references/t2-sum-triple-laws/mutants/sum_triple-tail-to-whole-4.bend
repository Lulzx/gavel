import Base
import ./prelude.bend as P

def sum_triple(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.triple(h) + sum_triple(xs)
