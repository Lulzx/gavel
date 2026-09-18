import Base

# The `(0n, 1n+bp)` case answers the second argument instead of `0n`, so the
# zero of the *first* argument is the only place where the answer is zero and
# the body is the second projection as soon as the first argument is zero. The
# diagonal law is satisfied at `x = 0n` and symmetry fails, since the body
# answers `y` where it should answer the `0n` it gives for `(y, 0n)`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['min_self'], first failure
# at `LAWS.min_comm`.
def min(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      1n+bp
    case 1n+ap 0n:
      0n
    case 1n+ap 1n+bp:
      1n+min(ap, bp)
