import Base

# The other identity body: `add` answers its first argument, so `add_plus` asks
# it for `x == x + y`. The match is on `a`, and the successor case answers the
# successor itself, which is the argument.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.add_plus`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      1n + p
