import Base

# Saturating subtraction that never subtracts: every case returns its first
# argument, so the law asks for `x + y == y` at a variable `y`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sub_saturates'], first
# failure at `LAWS.sub_cancel`.
def sub(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      0n
    case 1n+ap 0n:
      1n+ap
    case 1n+ap 1n+bp:
      1n+ap
