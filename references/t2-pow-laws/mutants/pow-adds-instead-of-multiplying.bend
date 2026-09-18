import Base

# The step adds the base instead of multiplying by it, so `pow` accumulates like
# a repeated sum: the slip of reaching for `+` where the recursion is the other
# operation. Rejected by `pow_one`, whose left-hand side reduces to
# `x + pow(x, 0n)`, which is `x + 1n`, where the law wants `x`. `pow_zero` holds
# -- the base case is the reference's -- so the law that reaches the step is the
# one that rejects this body.
def pow(a: Nat, b: Nat) -> Nat:
  match b:
    case 0n:
      1n
    case 1n+p:
      +x = a
      Nat.add(x, pow(x, p))
