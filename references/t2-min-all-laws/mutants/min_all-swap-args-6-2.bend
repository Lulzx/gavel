import Base
import ./prelude.bend as P

def min_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +k = n
      P.min(h, k) <> min_all(k, t)
