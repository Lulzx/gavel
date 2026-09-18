import Base
import ./prelude.bend as P

def sum_acc(xs: List<&2, Nat>, a: Nat) -> Nat:
  match xs:
    case Nil{}:
      a
    case h <> t:
      a + P.sum(h <> t)
