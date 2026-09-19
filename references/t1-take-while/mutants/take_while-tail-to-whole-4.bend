import Base
import ./prelude.bend as P

def take_while(xs: List<Nat>, +n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      P.keep_put(h, take_while(xs, n), P.le(h, n))
