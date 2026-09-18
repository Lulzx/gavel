import Base

# `min` is the first projection: the second argument is never consulted. The
# diagonal law `min(x, x) == x` is satisfied -- both arguments are the same
# number -- and the symmetry law is not, because the body answers `x` where
# the law asks for the answer to `(y, x)`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.min_self`.
def min(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      0n
    case 1n+ap 0n:
      1n+ap
    case 1n+ap 1n+bp:
      1n+ap
