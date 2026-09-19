import Base
import ./prelude.bend as P

def drop_while(+xs: List<&2, Nat>, +n: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      P.drop_put(h, t, drop_while(t, n), P.le(h, n))

    case h <> t:
      Nil{}
