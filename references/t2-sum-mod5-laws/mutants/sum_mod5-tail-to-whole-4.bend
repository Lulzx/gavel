import Base
import ./prelude.bend as P

def sum_mod5(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.mod5(h) + sum_mod5(xs)
