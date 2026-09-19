import Base

# Every successor is answered with zero: the `1n+` is dropped from the answer
# as well as from the recursion. `pred_succ` asks for `x` at a variable `x`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['add_one', 'pred_zero'],
# first failure at `LAWS.pred_succ`.
def pred(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+p:
      0n

def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)
