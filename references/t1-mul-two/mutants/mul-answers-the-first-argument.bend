import Base

# `mul` answers its first argument: the zero law holds at its own base (both
# sides are `0n`) and the two law fails, where `S.mul(2n, x)` is `2n` and the
# right-hand side is `x + x`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['mul_zero', 'add_zero'],
# first failure at `LAWS.mul_two`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      1n + p
