import Base
import ./prelude.bend as P

def sum_mod3(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.mod3(h) + sum_mod3(xs)
