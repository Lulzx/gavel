import Base

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      1n
    case 1n+p:
      b + mul(p, b)
