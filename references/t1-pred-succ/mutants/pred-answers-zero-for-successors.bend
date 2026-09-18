import Base

# The successor case answers `0n`, so `pred` is zero past the base: the first
# law asks it for `x` at a variable, and the second law asks for `x` through
# `S.add` as well.
# Measured: `proof_tier=3 bare_tier=2`, proven ['pred_zero'], first failure
# at `LAWS.pred_succ`.
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
      0n
