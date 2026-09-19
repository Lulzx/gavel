import Base
import ./prelude.bend as P

def drop_while(+xs: List<&2, Nat>, +n: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.drop_put(h, t, drop_while(t, +xs), P.le(h, n))
