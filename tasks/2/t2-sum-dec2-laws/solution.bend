import Base
import ./prelude.bend as P

# TODO(policy): implement. `sum_dec2(xs)` adds up the element minus two, saturating at zero for every element of
# `xs`. Match on the list: `Nil{}` adds nothing, and a cons cell adds the element minus two, saturating at zero
# to the sum for its tail. `append` and `dec2` come from the prelude.
def sum_dec2(xs: List<Nat>) -> Nat:
  ?TODO
