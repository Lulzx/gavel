import Base

# The predecessor is the reference's and `add` is not: with `add` answering its
# second argument, `S.add(x, 1n)` is `1n`, so the second law asks for
# `pred(1n) == x` -- `0n` against a variable.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.add_one_comm`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      b

def pred(a: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      p
