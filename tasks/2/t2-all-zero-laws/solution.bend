import Base
import ./prelude.bend as P

# TODO(policy): implement. `all_zero(xs)` answers whether every element of
# `xs` is zero, which the empty list is, vacuously. Match on the list: `Nil{}`
# gives `True{}`, and a cons cell ands its head's test into the answer for its
# tail; `append` and `is_zero_b` come from the prelude.
def all_zero(xs: List<Nat>) -> Bool:
  ?TODO
