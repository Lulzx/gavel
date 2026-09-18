import Base

def drop(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 1n:
      xs
    case 1n+k:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          drop(k, t)
