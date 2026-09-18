import Base
import ./prelude.bend as P

def take(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      match n:
        case 0n:
          Nil{}
        case 1n+p:
          h <> take(t, p)
