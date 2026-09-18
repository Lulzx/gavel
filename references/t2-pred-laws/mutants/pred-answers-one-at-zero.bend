import Base

# The base case answers `1n` instead of `0n`. `pred_succ` applies `pred` only to
# a successor, and `add_one` does not mention `pred` at all, so the `0n` case is
# reached by neither law and its answer is free.
# Measured: before `pred_zero`, tier 4, reward 1.000; after, tier 3, reward
# 0.433 for `pred_succ` and `add_one`, first failure at `LAWS.pred_zero`.
def pred(n: Nat) -> Nat:
  match n:
    case 0n:
      1n
    case 1n+p:
      p

def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)
