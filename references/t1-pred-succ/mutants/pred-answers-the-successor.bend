import Base

# The successor case answers one more than its argument, so `pred` adds instead
# of removing: `pred(1n+x)` is `1n+1n+x` against the law's `x`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.pred_succ`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)

def pred(a: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      1n + 1n + p
