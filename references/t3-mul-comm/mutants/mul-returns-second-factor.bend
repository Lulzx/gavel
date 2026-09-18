import Base

# The other identity body: `mul` answers its second argument. `mul_zero_right`
# contradicts it the same way and `mul_one_right` does too -- with the right
# factor `1n` the left-hand side computes to `1n` and the law wants the
# variable `x`. `mul_comm` is false of it as well, since `mul(b, a)` is the
# other variable. Measured: `proof_tier=2 bare_tier=2`, nothing proven, first
# failure at `Policy.mul_zero_right`, all four laws listed as failed.
def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      b
