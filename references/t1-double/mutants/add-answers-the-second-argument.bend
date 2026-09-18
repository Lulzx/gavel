import Base

# `add` answers its second argument, so the pair's first law becomes
# `S.double(x) == x`: with the reference's `double` the left-hand side is `2x`
# and the right-hand side is the variable itself. The second law holds -- both
# sides go through `S.add` and it never reads its first argument consistently.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.add_succ_rev`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      b

def double(a: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      1n + 1n + double(p)
