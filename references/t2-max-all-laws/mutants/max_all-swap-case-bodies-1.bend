import Base
import ./prelude.bend as P

def max_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      +k = n
      P.max(h, k) <> max_all(t, k)

    case h <> t:
      Nil{}
