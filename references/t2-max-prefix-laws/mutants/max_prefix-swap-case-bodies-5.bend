import Base
import ./prelude.bend as P

def max_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          P.max(h, max_prefix(k, t))

        case h <> t:
          0n
