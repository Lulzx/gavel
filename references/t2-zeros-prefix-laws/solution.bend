import Base
import ./prelude.bend as P

def zeros_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          0n
        case h <> t:
          P.is_zero(h) + zeros_prefix(k, t)
