import Base

# The step adds two copies of the second factor instead of one, so `mul` is
# twice the product. Multiplication by one becomes `2n`, and the left-identity
# law fails at a variable `x`.
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
      0n
    case 1n+p:
      add(b, add(b, mul(p, b)))
