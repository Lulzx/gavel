import Base
import ./prelude.bend as P

def sum_sq_inc(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.sq_inc(h) + sum_sq_inc(xs)
