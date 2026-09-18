import Base

# The answer is two for every non-empty argument: the step is present, adds
# correctly, and does not call `double`. `double_eq_add` asks it for
# `1n+1n == S.add(x, x)` at a variable `x`, which is not convertible.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.double_eq_add`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)

def double(a: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      1n + 1n
