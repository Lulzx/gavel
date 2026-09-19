import Base
import ./prelude.bend as P

# TODO(policy): implement. `is_prefix(xs, ys)` answers whether `xs` is the
# first part of `ys`. Recurse on both lists: the empty list is a prefix of
# everything, a cons cell is not a prefix of the empty list, and a cons cell is
# a prefix of another cons cell when the heads are equal and the tails are a
# prefix. `P.eq` and `Bool.and` come from the prelude and `Base`.
def is_prefix(xs: List<Nat>, ys: List<Nat>) -> Bool:
  ?TODO
