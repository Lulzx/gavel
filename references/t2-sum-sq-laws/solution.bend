import Base
import ./prelude.bend as P

def sq_sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.sq(h) + sq_sum(t)
