import Base
import ./prelude.bend as P

def count_below(+x: Nat, xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.cb_put(count_below(x, t), P.le(h, x))

def count_above(+x: Nat, xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      0n
