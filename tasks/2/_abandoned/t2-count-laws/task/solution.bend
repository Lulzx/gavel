import Base
import ./prelude.bend as P

# TODO(policy): implement. `count(xs, n)` is the number of elements of `xs` that
# equal `n`. Match on the list: `Nil{}` counts none, and a cons cell adds
# `P.eq(h, n)` -- which is `1n` or `0n` -- to the count of its tail.
#
# The step names `n` twice, and a binder is consumed on every use, so re-bind it
# reusable inside the step with `+k = n`.
def count(xs: List<Nat>, n: Nat) -> Nat:
  ?TODO
