import Base
import ./prelude.bend as P

# TODO(policy): implement. `min_first(xs)` answers the elements of `xs` with the
# smallest one moved to the front, the rest keeping their order. Recurse on
# `xs`: `Nil{}` answers `Nil{}`, and a cons cell hands the head and the tail's
# own answer to `P.mf_put`, which is where the comparison lives. `P.le`,
# `P.len`, `P.mf_dec` and `P.mf_put` are the prelude's and are immutable.
def min_first(xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
