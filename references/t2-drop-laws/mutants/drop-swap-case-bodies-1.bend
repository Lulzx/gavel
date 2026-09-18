import Base

def drop(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          drop(k, t)

    case 1n+k:
      xs
