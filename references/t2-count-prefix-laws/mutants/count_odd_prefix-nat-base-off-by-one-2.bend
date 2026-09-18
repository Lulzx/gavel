import Base
import ./prelude.bend as P

def count_odd_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 1n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          0n
        case h <> t:
          P.is_odd(h) + count_odd_prefix(k, t)
