import Base

# The identity body: `mul` answers its first argument, so the recursion is
# written and the answer is the argument itself. It satisfies `mul_one_right`
# (the right-hand side of that law is the variable `x`) and is what that law is
# blind to; `mul_zero_right` is the law that contradicts it, since the
# left-hand side computes to the variable `x` and the law wants `0n`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.mul_zero_right`; all four laws listed as failed.
def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      1n + p
