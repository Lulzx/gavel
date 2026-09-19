import Base
import ./prelude.bend as P

# TODO(policy): implement both. `count_below(x, xs)` is how many elements of
# `xs` are at most `x`, and `count_above(x, xs)` how many are above it. Both
# recurse on `xs`: the empty list counts nothing, and a cons cell hands the
# count of its tail and the predicate's answer for its head to `P.cb_put` or
# `P.ca_put`. `x` is read twice in a cons cell -- once for the predicate and
# once for the recursion -- so it is declared `+x`.
def count_below(+x: Nat, xs: List<&2, Nat>) -> Nat:
  ?TODO

def count_above(+x: Nat, xs: List<&2, Nat>) -> Nat:
  ?TODO
