import Base

# The step answers `0n` while the base is the reference's, so `mul` is zero
# everywhere. The zero law holds by reduction at every argument; the two law
# fails, since `S.mul(2n, x)` is `0n` against `x + x`.
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
      0n
