import Base
import ./prelude.bend as P

def sum_succ2(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      P.succ2(h) + sum_succ2(t)

    case h <> t:
      0n
