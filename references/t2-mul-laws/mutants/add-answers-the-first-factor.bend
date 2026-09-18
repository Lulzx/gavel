import Base

# `add` returns its first argument: the base case answers `0n` rather than the
# addend, which makes every sum the augend. Multiplication by one still
# reduces correctly, and the successor law fails because the accumulated copy
# of the first factor is dropped at the last step.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.add_succ`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      1n + add(p, b)

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      add(b, mul(p, b))
