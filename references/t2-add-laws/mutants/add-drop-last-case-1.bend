import Base

def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
