import Base
import ./prelude.bend as P

def sum_nonzero(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.is_nonzero(h) + sum_nonzero(t)
