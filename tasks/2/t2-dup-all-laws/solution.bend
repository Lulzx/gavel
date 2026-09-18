import Base
import ./prelude.bend as P

# TODO(policy): implement. `dup_all(xs)` repeats every element twice, so the
# result is twice as long as its input. Match on the list: `Nil{}` is `Nil{}`,
# and a cons cell conses its head twice in front of the duplicated tail.
#
# The step names the head twice, and a binder is consumed on every use, so
# re-bind it reusable inside the step with `+h2 = h`.
def dup_all(xs: List<Nat>) -> List<Nat>:
  ?TODO
