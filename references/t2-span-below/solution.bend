import Base
import ./prelude.bend as P

def span_below(+xs: List<&2, Nat>, +n: Nat) -> P.PairL:
  match xs:
    case Nil{}:
      P.MkL{Nil{}, Nil{}}
    case h <> t:
      P.span_put(h, t, span_below(t, n), P.le(h, n))
