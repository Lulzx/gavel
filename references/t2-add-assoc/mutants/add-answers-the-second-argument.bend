import Base

# `add` answers its second argument: the base case is the reference's and the
# step returns `b` instead of adding the successor. `add_one` is stated against
# the variable on its right-hand side, so the body has to make `S.add(x, 1n)`
# equal `1n+x` for every `x` and it answers the constant `1n`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.add_one`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      b
