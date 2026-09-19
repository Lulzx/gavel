import Base
import ./prelude.bend as P

def is_prefix(xs: List<Nat>, ys: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      match ys:
        case Nil{}:
          False{}
        case k <> u:
          Bool.and(P.eq(h, k), is_prefix(t, u))
