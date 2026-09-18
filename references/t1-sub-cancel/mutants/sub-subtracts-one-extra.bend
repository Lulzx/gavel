import Base

# The subtraction is off by one wherever the subtrahend is gone: the case with
# `0n` as the second argument answers the predecessor of the first. The law
# reaches it at `y = 1n + ...`, where the right-hand side is the variable and
# this body answers one less.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.sub_zero_right`.
def sub(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      0n
    case 1n+ap 0n:
      ap
    case 1n+ap 1n+bp:
      sub(ap, bp)
