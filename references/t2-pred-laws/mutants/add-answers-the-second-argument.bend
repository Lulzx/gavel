import Base

# `add` returns its second argument: the recursion is dropped from the
# successor case, so `add(x, 1n)` is `1n` where `add_one` asks for `1n+x`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['pred_succ', 'pred_zero'],
# first failure at `LAWS.add_one`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      b

def pred(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+p:
      p
