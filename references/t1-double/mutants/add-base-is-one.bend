import Base

# The base case is off by one, so `add` is one more than the sum and `double` is
# one more than the double. The two laws are both off by the same amount and
# neither of them compares the pair against a Base term, so what catches this is
# the arithmetic of the law's own right-hand side; measured below.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.add_succ_rev`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      1n
    case 1n+p:
      1n + add(p, b)

def double(a: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      1n + 1n + double(p)
