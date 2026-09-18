import Base

# Two positive arguments are answered with `1n` rather than `1n + min(ap, bp)`:
# the recursion is dropped from the last case. The diagonal law fails at
# `x = 2n`, where the body answers `1n`, and the statement is at a variable
# `x`, so the proof never gets that far.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.min_self`.
def min(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      0n
    case 1n+ap 0n:
      0n
    case 1n+ap 1n+bp:
      1n
