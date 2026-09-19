import Base

# `mul` answers its first argument, so `mul(x, 0n)` is the variable itself and
# the zero law fails at any `x` above one.
# Measured: `proof_tier=3 bare_tier=2`, proven ['add_plus',
# 'mul_zero_left'], first failure at `LAWS.mul_zero`.
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
