import Base

def pow(a: Nat, b: Nat) -> Nat:
  match b:
    case 0n:
      1n
