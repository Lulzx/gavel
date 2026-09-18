import Base
import ./prelude.bend as P

def sum_acc(xs: List<&2, Nat>, a: Nat) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      sum_acc(t, a + h)
