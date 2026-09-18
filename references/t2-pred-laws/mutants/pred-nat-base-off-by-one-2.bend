import Base

def pred(n: Nat) -> Nat:
  match n:
    case 1n:
      0n
    case 1n+p:
      p

def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)
