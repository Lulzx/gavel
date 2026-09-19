import Base

# `add` returns its first argument, so the sum never picks up the addend. The
# law `add_one` asks for `1n+x` and the body leaves `x`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['pred_succ', 'pred_zero'],
# first failure at `LAWS.add_one`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      1n + add(p, b)

def pred(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+p:
      p
