import Base

def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      1n + add(p, b)

    case 1n+p:
      b

def pred(a: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      p
