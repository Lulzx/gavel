import Base
import ./prelude.bend as P

# TODO(policy): implement. `elem_zero(xs)` answers whether `xs` holds a zero.
# The empty list holds none, and a cons cell ors its head's zero test into the
# answer for its tail. Note that `Bool.or` matches on its first argument, so the
# recursion has to sit on the right of the `or`.
def elem_zero(xs: List<Nat>) -> Bool:
  ?TODO
