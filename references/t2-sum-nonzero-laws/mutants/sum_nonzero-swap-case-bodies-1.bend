import Base
import ./prelude.bend as P

def sum_nonzero(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      P.is_nonzero(h) + sum_nonzero(t)

    case h <> t:
      0n
