import Base
import ./prelude.bend as P

def sum_mod3(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      P.mod3(h) + sum_mod3(t)

    case h <> t:
      0n
