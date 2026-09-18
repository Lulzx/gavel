import Base

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 1n:
      0n
    case 1n+p:
      b + mul(p, b)
