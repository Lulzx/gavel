import Base
import ./prelude.bend as P

def sq_sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      P.sq(h) + sq_sum(t)

    case h <> t:
      0n
