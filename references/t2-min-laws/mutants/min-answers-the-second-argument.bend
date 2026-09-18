import Base

# `min` is the second projection. As with the first projection the diagonal
# law holds and symmetry fails: the body answers the argument that is in the
# wrong position.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.min_self`.
def min(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      1n+bp
    case 1n+ap 0n:
      0n
    case 1n+ap 1n+bp:
      1n+bp
