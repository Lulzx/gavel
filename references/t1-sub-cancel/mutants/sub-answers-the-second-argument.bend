import Base

# The result is always the second argument: right where the law has `x` on the
# right and `0n` as the subtrahend, wrong everywhere the first argument is the
# sum. The law fails at `sub(x + y, x)` with `x` and `y` variables.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.sub_zero_right`.
def sub(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      1n+bp
    case 1n+ap 0n:
      0n
    case 1n+ap 1n+bp:
      1n+bp
