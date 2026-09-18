import Base
import ./prelude.bend as P

def sub_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +k = n
      P.sub(h, k) <> sub_all(t, xs)
