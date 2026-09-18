import Base

# The step keeps its recursion and drops the addition, so `mul` counts
# successors without ever adding the factor: `mul(x, b)` is `0n` for every `x`
# and `b`. `mul_one_right` contradicts it (the left-hand side is `0n`, the law
# wants the variable `x`); `mul_zero_right` happens to hold. Measured:
# `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.mul_succ_right`.
def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      mul(p, b)
