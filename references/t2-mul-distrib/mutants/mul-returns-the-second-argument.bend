import Base

# The projection onto the second argument -- the mirror of the sibling body, and
# the other half of what the law set's prose says the two laws are for.
# Rejected by `mul_distrib` as a statement: at a variable `z` the left-hand side
# is `z` where the right-hand side is `z + z`. `mul_one_left` is true of the
# body, since `mul(1n, x)` is `x` here, and the checker rejects it anyway, in
# that law's own definition: its step rewrites `p` into `p + 0n` with
# `Policy.add_zero_right`, which is a step written for a body that builds its
# answer out of `p`, and this one has no `p` in it at all.
def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      b
