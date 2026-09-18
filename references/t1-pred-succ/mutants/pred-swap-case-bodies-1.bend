import Base

def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)

def pred(a: Nat) -> Nat:
  match a:
    case 0n:
      p

    case 1n+p:
      0n
