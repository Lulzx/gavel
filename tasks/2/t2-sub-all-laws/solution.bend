import Base
import ./prelude.bend as P

# TODO(policy): implement. `sub_all(xs, n)` subtracts `n` from every element,
# `P.sub(h, n)`. Match on the list: `Nil{}` is `Nil{}`, and a cons cell conses
# the reduced head onto the reduced tail.
#
# The step names `n` twice, and a binder is consumed on every use, so re-bind it
# reusable inside the step with `+k = n`.
def sub_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  ?TODO
