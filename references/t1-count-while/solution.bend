import Base
import ./prelude.bend as P

def count_while(xs: List<Nat>, +n: Nat) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.count_put(count_while(t, n), P.le(h, n))
