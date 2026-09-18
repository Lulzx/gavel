import Base

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      b + mul(p, b)

    case 1n+p:
      0n
