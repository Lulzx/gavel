import Base

# The constant body: every call answers `0n`. The law's comment names it as the
# last of the four argument-ignoring bodies (`0n` answers `0n == x + y`), and it
# is the body that the right-hand side's Base term rejects without needing a
# variable to be unequal to anything.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.add_plus`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      0n
