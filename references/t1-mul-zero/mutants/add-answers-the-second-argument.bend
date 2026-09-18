import Base

# The multiplication is the reference's and `add` answers its second argument,
# so every step of `mul` returns the accumulated product unchanged: `mul` is
# `0n`. The zero law holds by reduction (both sides are zero); the successor law
# asks for `y + S.mul(x, y)` and this body never adds `y`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.add_plus`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      b

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      add(b, mul(p, b))
