import Base

# The empty case is off by one and the rest is the reference's, so `sub(0n, 0n)`
# is `1n`. The law's own base case -- `x` and `y` both zero -- is the case the
# body gets wrong, and the measured first failure is the proof's base helper.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.sub_zero_right`.
def sub(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      1n
    case 0n 1n+bp:
      0n
    case 1n+ap 0n:
      1n+ap
    case 1n+ap 1n+bp:
      sub(ap, bp)
