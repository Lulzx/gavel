import Base
import ./prelude.bend as P

# TODO(policy): implement. `min_all(xs, n)` caps every element above `n` down to
# `n`, `P.min(h, n)`. Match on the list: `Nil{}` is `Nil{}`, and a cons cell
# conses the capped head onto the capped tail.
#
# The step names `n` twice, and a binder is consumed on every use, so re-bind it
# reusable inside the step with `+k = n`.
def min_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  ?TODO
