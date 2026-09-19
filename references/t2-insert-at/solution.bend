import Base
import ./prelude.bend as P

def insert_at(n: Nat, xs: List<Nat>, y: Nat) -> List<Nat>:
  match n:
    case 0n:
      y <> xs
    case 1n+p:
      match xs:
        case Nil{}:
          y <> Nil{}
        case h <> t:
          h <> insert_at(p, t, y)
