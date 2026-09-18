import Base
import ./prelude.bend as P

def filter(xs: List<Nat>, +n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      P.filter_put(h, filter(t, n), P.le(h, n))

    case +h <> t:
      Nil{}

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
