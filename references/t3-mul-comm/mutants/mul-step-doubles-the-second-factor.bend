import Base

# The step adds the factor twice, so the answer is the product of the left
# factor with twice the right one: `mul(x, b)` is `x * (2 * b)` written in the
# successor form. The easy right-factor laws still hold at `1n` and `0n`
# (doubling those is the identity), so this is the body that needs the
# induction laws: `mul_succ_right`'s step has one copy of the factor on each
# side and this body produces two. Measured: `proof_tier=2 bare_tier=2`,
# nothing proven, first failure at `Policy.mul_succ_right`.
def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      b + b + mul(p, b)
