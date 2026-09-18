import Base

def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, a)

def pred(a: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      p
