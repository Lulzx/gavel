import Base

# The step answers `0n` and the base is the reference's, so `mul` is zero
# everywhere. The right-zero law holds by reduction at every `x`; the successor
# law is `S.mul(1n+x, y) == y + S.mul(x, y)`, and this body answers `0n` where
# the law wants `y + 0n`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.mul_zero`.
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
