import Base
import ./prelude.bend as P

def delete_at(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          xs
    case 1n+p:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          h <> delete_at(p, t)
