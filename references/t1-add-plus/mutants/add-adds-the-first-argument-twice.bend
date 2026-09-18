import Base

# `add` returns the double of its first argument, which the law's comment names
# as the `a + a` body: `add_plus` asks it for `x + x == x + y`. The successor
# variable is used twice, so the branch rebinds it; the second argument is never
# read.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.add_plus`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      +p = p
      (1n + p) + (1n + p)
