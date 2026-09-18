import Base
import ./prelude.bend as P

# TODO(policy): implement. `count_odd(xs)` counts how many elements of `xs` are
# odd. Match on the list: `Nil{}` counts none, and a cons cell adds
# `P.is_odd(h)` -- which is `1n` or `0n` -- to the count for its tail. `append`
# and `is_odd` come from the prelude.
def count_odd(xs: List<Nat>) -> Nat:
  ?TODO
