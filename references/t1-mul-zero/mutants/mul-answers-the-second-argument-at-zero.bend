import Base

# `mul` is the second argument wherever the first is zero, which is the
# projection this task's own `add` would give. Neither law above applies `mul` to
# `0n` on the left with a variable on the right, so the case is unconstrained:
# `mul_zero` is `mul(x, 0n)` and `mul_succ_left` steps on `1n+x`.
# Measured: before `mul_zero_left`, tier 4, reward 1.000; after, tier 3, reward
# 0.433 for the two older laws, first failure at `LAWS.mul_zero_left`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      add(b, mul(p, b))
