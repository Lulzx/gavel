import Base
import ./prelude.bend as P

def min_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      +k = n
      P.min(h, k) <> min_all(t, k)

    case h <> t:
      Nil{}
