import Base
import ./prelude.bend as P

# TODO(policy): implement. `has_one(xs)` answers whether `xs` holds a `1n`,
# which the empty list does not. Match on the list: `Nil{}` gives `False{}`,
# and a cons cell ors its head's test into the answer for its tail; `append`
# and `is_one_b` come from the prelude.
def has_one(xs: List<Nat>) -> Bool:
  ?TODO
