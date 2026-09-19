import Base
import ./prelude.bend as P

def count_matches(xs: List<Nat>, ys: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      match ys:
        case Nil{}:
          0n
        case k <> u:
          P.pick(P.eq(h, k), 1n, 0n) + count_matches(t, ys)
