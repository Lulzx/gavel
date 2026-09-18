import Base
import ./prelude.bend as P

def count(xs: List<Nat>, n: Nat) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      +k = n
      P.eq(k, h) + count(t, k)
