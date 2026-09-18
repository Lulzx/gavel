import Base

def pow(a: Nat, b: Nat) -> Nat:
  match b:
    case 1n:
      1n
    case 1n+p:
      +x = a
      Nat.mul(x, pow(x, p))
