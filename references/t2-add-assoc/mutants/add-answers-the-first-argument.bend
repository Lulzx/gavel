import Base

# The identity body: `add` returns its first argument, so every one of the
# laws asks it for something the body does not do. `add_one` is the one that
# fails first, at its own base case (`0n` against `1n+0n`).
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.add_one`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      1n + p
