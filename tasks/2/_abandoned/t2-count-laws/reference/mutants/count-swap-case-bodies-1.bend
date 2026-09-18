import Base
import ./prelude.bend as P

def count(xs: List<Nat>, n: Nat) -> Nat:
  match xs:
    case Nil{}:
      +k = n
      P.eq(h, k) + count(t, k)

    case h <> t:
      0n
