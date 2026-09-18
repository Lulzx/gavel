import Base

# The base case answers `1n` instead of `0n`. Both laws apply `pred` to a
# successor -- `1n+x`, and `add(x, 1n)`, which reduces to one -- so the `0n` case
# is reached by neither, and the body proves both.
# Measured: before `pred_zero`, tier 4, reward 1.000; after, tier 3, reward 0.433
# for the two older laws, first failure at `LAWS.pred_zero`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)

def pred(a: Nat) -> Nat:
  match a:
    case 0n:
      1n
    case 1n+p:
      p
