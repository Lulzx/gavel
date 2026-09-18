import Base
import ./prelude.bend as P

# TODO(policy): implement. `all_one(xs)` answers whether every element of `xs`
# is `1n`, which the empty list is, vacuously. Match on the list: `Nil{}` gives
# `True{}`, and a cons cell ands its head's test into the answer for its tail;
# `append` and `is_one_b` come from the prelude.
def all_one(xs: List<Nat>) -> Bool:
  ?TODO
