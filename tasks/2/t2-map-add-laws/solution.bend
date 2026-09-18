import Base
import ./prelude.bend as P

# TODO(policy): implement. `map_add(xs, n)` adds `n` to every element of `xs`:
# `Nil{}` stays `Nil{}`, a cons cell conses `h + n` onto the result for the
# tail, and `n` itself is carried along unchanged.
def map_add(xs: List<Nat>, n: Nat) -> List<Nat>:
  ?TODO
