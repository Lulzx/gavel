import Base

# `mul` answers its second argument: `mul(x, 0n)` is `0n` at every `x`, so the
# zero law's statement holds of this body, and the successor law's does not
# (`S.mul(1n+x, y)` is `y` against `y + S.mul(x, y)`). The checker reports both
# as failed off the shared unfolding; the law the body contradicts is the
# successor law.
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
      b
