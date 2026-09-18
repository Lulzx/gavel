import Base
import ./prelude.bend as P

def sum_pow2(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      P.pow2(h) + sum_pow2(t)

    case h <> t:
      0n
