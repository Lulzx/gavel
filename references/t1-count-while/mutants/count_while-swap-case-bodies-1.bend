import Base
import ./prelude.bend as P

def count_while(xs: List<Nat>, +n: Nat) -> Nat:
  match xs:
    case Nil{}:
      P.count_put(count_while(t, n), P.le(h, n))

    case h <> t:
      0n
