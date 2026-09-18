import Base

# The successor case answers the number itself rather than its predecessor, so
# `pred` is the identity. `pred_succ` asks for `x` where the body leaves `1n+x`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['add_one'], first failure at
# `LAWS.pred_succ`.
def pred(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+p:
      1n+p

def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)
