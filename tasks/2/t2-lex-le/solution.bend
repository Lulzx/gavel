import Base
import ./prelude.bend as P

# TODO(policy): implement. `lex_le(xs, ys)` answers whether `xs` is
# lexicographically at most `ys`. The empty list on the left is at most anything
# and a non-empty list against the empty one is not; two cons cells are decided
# by their heads -- `P.lt(h, k)` says the answer outright, and `P.eq(h, k)` says
# whether the tie falls through to the tails, whose own comparison is the
# answer. Both list types are `List<&2, Nat>`.
def lex_le(xs: List<&2, Nat>, ys: List<&2, Nat>) -> Bool:
  ?TODO
