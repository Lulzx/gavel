import Base
import ./prelude.bend as P

def is_prefix(xs: List<Nat>, ys: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      match ys:
        case Nil{}:
          Bool.and(P.eq(h, k), is_prefix(t, u))

        case k <> u:
          False{}
