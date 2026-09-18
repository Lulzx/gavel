import Base

# The last case forgets to add the `1n` back after the recursive call, so the
# answer is short by one for every pair of positive arguments. The diagonal
# law fails: `min(2n, 2n)` is `1n`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['min_zero_left'], first
# failure at `LAWS.min_self`.
def min(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      0n
    case 1n+ap 0n:
      0n
    case 1n+ap 1n+bp:
      min(ap, bp)
