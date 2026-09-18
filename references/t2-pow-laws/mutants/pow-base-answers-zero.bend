import Base

# The zero exponent answered with zero rather than one: the slip of carrying the
# multiplicative identity of the wrong operation into the base case. Rejected by
# `pow_zero`, whose left-hand side reduces to `0n` where the law wants `1n`, and
# by `pow_one` as well: the step is the reference's, so `pow(x, 1n)` reduces to
# `Nat.mul(x, pow(x, 0n))`, which is `Nat.mul(x, 0n)` and then `0n`, where the
# law wants `x`. The checker stops at `pow_zero`, the first of the two.
def pow(a: Nat, b: Nat) -> Nat:
  match b:
    case 0n:
      0n
    case 1n+p:
      +x = a
      Nat.mul(x, pow(x, p))
