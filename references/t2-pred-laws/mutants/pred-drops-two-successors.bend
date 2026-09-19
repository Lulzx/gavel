import Base

# The successor case takes the predecessor of the predecessor instead of
# answering it, so `pred` counts down by two and `pred(1n)` is `0n`. The law
# asks for `x` at a variable `x` and the body leaves `pred(x)`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['add_one', 'pred_zero'],
# first failure at `LAWS.pred_succ`.
def pred(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+p:
      pred(p)

def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)
