import Base

def at(xs: List<Nat>, n: Nat) -> Nat:
  match xs:
    case Nil{}:
      match n:
        case 0n:
          h
        case 1n+k:
          at(t, k)

    case h <> t:
      0n
