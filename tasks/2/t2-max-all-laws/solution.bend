import Base
import ./prelude.bend as P

# TODO(policy): implement. `max_all(xs, n)` raises every element below `n` to
# `n`, `P.max(h, n)`. Match on the list: `Nil{}` is `Nil{}`, and a cons cell
# conses the raised head onto the raised tail.
#
# The step names `n` twice, and a binder is consumed on every use, so re-bind it
# reusable inside the step with `+k = n`.
def max_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  ?TODO
