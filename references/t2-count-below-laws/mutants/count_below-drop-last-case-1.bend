import Base
import ./prelude.bend as P

def count_below(+x: Nat, xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n

def count_above(+x: Nat, xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.ca_put(count_above(x, t), P.le(h, x))
