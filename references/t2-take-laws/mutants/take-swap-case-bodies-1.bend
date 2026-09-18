import Base
import ./prelude.bend as P

def take(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          h <> take(k, t)

    case 1n+k:
      Nil{}
