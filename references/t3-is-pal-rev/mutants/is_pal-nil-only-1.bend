import Base
import ./prelude.bend as P

# Says `xs` is a palindrome exactly when it is empty. `is_pal_nil` holds by
# computation and `is_pal_two_distinct` holds as well -- `0n <> 1n` is not empty
# -- so the pin that sees this one is `is_pal_single`: its left-hand side is
# `False{}` and its right-hand side is `True{}`.
def is_pal(+xs: List<&2, Nat>) -> Bool:
  P.eq_list(xs, Nil{})
