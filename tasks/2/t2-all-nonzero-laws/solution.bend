import Base
import ./prelude.bend as P

# TODO(policy): implement. `all_nonzero(xs)` answers whether every element of
# `xs` is nonzero, which the empty list is vacuously. A cons cell ands its
# head's test into the answer for its tail. Note that `Bool.and` matches on its
# first argument, so the recursion has to sit on the right of the `and`.
def all_nonzero(xs: List<Nat>) -> Bool:
  ?TODO
