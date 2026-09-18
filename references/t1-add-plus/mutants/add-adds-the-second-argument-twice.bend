import Base

# The mirror: `add` returns the double of its *second* argument, the `b + b`
# body of the law's comment, which the law asks for `y + y == x + y`. The
# parameter is used twice, so the signature marks it `+`; the first argument is
# read only by the match.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.add_plus`.
def add(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      b + b
