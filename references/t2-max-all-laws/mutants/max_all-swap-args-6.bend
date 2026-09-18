import Base
import ./prelude.bend as P

def max_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +k = n
      P.max(k, h) <> max_all(t, k)
