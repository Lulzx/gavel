import Base
import ./prelude.bend as P

def take_while(xs: List<Nat>, +n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      P.keep_put(h, take_while(t, n), P.le(h, n))

    case +h <> t:
      Nil{}
