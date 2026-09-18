import Base

# The step adds zero instead of the second argument, so `add(x, y)` is `x` for
# every `x` above zero: the base case is right and the recursion loses the
# addend on the way up. The associativity law fails on the two sides'
# rightmost addend, and `add_one` fails as well.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.add_one`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, 0n)
