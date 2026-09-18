import Base

# `mul` is the second projection: both cases answer `b`. Multiplication by one
# is then multiplication by the wrong factor, and the left-identity law asks
# for `x` where the body leaves `x`'s value inside the recursion.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.mul_one_left`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      b
