import Base
import ./prelude.bend as P

def cmp(a: Nat, b: Nat) -> P.Tri:
  match a:
    case 0n:
      match b:
        case 0n:
          P.Eq{}
        case 1n+q:
          P.Lt{}
    case 1n+p:
      match b:
        case 1n:
          P.Gt{}
        case 1n+q:
          cmp(p, q)
