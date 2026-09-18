import Base
import ./prelude.bend as P

# TODO(policy): implement both. `insert(xs, y)` returns `xs` with `y` inserted;
# `isort(xs)` sorts `xs` by inserting its elements into the sorted tail. Both
# recurse on `xs`. `P.le`, `P.insert_put`, `P.eq`, `P.ind`, `P.count_put` and
# `P.count` are the prelude's and are immutable.
def insert(xs: List<&2, Nat>, +y: Nat) -> List<&2, Nat>:
  ?TODO

def isort(xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
