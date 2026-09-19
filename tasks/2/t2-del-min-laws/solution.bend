import Base
import ./prelude.bend as P

# TODO(policy): implement. `del_min(xs)` answers the elements of `xs` with one
# occurrence of the smallest one removed, the rest keeping their order.
# Recurse on `xs`: `Nil{}` answers `Nil{}`, and a cons cell hands the head and
# the tail to `P.dm_put`, which is where the comparison lives. `P.le`,
# `P.len`, `P.min2`, `P.min_go`, `P.dm_put` and `P.dm_dec` are the prelude's
# and are immutable.
def del_min(xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
