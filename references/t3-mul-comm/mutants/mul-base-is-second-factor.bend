import Base

# The recursion is the reference's and only the base case is wrong: at zero the
# body answers the second factor instead of `0n`, so `mul(0n, b)` is `b` for
# every `b` and the zero law is contradicted at its own induction's base. It is
# the smallest body that separates "the recursion was followed" from "the base
# case was chosen", and the generated off-by-one mutant changes the same case
# the other way (`case 1n:`) so the two are not redundant. Measured:
# `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.mul_succ_right` -- the zero law's own induction does not replay with
# the base changed under it.
def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      b + mul(p, b)
