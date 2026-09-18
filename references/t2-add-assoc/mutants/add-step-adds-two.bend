import Base

# The step adds two successors instead of one, so `add(x, y)` is `2x + y`:
# a plausible off-by-one when the step is written out without the unary
# successor in view. `add_one` asks for `1n+x` and gets `2x + 1n`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.add_one`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + 1n + add(p, b)
