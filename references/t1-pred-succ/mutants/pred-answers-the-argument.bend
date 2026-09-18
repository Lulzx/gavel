import Base

# The successor case answers the successor, so `pred` is the identity and the
# first law asks it for `1n+x == x`. The generated body for the same mistake
# changes only the pattern; this one is written out as the identity both laws
# have to reject.
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
      1n + p
