import Base

# The projection onto the first argument: the recursion is gone and the product
# is one of the factors. This is the body the law set's prose names -- it is the
# projection that `mul_one_left` exists to kill, since distributivity is true of
# it (`x + y` on both sides at a variable `z`) and `1n * x` is `1n`. Rejected by
# `mul_one_left`: its left-hand side reduces to `1n` where the law wants `x`.
# The checker stops in that law's own definition, whose step rewrites with
# `Policy.add_zero_right` to turn `p` into `p + 0n` on the right-hand side; the
# left-hand side this body produces is `1n`, which no such rewrite reaches.
def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      1n+p
