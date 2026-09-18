import Base

def at(xs: List<Nat>, n: Nat) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      match n:
        case 0n:
          h
        case 1n+k:
          h
