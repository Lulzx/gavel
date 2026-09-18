import Base
import ./prelude.bend as P

# TODO(policy): implement. `sum_nonzero(xs)` counts how many elements of `xs`
# are not zero. Match on the list: `Nil{}` adds nothing, and a cons cell adds
# `P.is_nonzero(h)` -- which is `1n` or `0n` -- to the sum for its tail. `append`
# and `is_nonzero` come from the prelude.
def sum_nonzero(xs: List<Nat>) -> Nat:
  ?TODO
