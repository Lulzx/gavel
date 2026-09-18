import Base

# The multiplication is the reference's and the addition is off by one at its
# base, so every partial product carries an extra one: `S.mul(x, 0n)` is `x` and
# the right-zero law fails at a variable. The successor law fails with it,
# since its right-hand side is the same addition.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.add_plus`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      1n
    case 1n+p:
      1n + add(p, b)

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      add(b, mul(p, b))
