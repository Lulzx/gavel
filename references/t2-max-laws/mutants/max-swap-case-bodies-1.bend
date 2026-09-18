import Base

def max(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      1n+max(ap, bp)

    case 0n 1n+bp:
      1n+bp
    case 1n+ap 0n:
      1n+ap
    case 1n+ap 1n+bp:
      0n
