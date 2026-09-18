import Base

# The step multiplies by the base twice for one decrement of the exponent, so
# `pow(2n, 2n)` is `8n`: an off-by-one in which part of the term is repeated,
# plausible when the multiplication is being written out by hand. Rejected by
# `pow_one`, whose left-hand side reduces to `Nat.mul(x, Nat.mul(x, pow(x, 0n)))`,
# which is `Nat.mul(x, x)`, where the law wants `x`. `pow_zero` holds -- the base
# case is the reference's -- so the law that reaches the step is the one that
# rejects this body.
def pow(a: Nat, b: Nat) -> Nat:
  match b:
    case 0n:
      1n
    case 1n+p:
      +x = a
      Nat.mul(x, Nat.mul(x, pow(x, p)))
