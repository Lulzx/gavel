import Base
import ./prelude.bend as P

def sum_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      match xs:
        case Nil{}:
          0n
        case h <> t:
          h + sum_prefix(k, t)

    case 1n+k:
      0n
