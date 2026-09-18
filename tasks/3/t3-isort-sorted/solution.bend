import Base
import ./prelude.bend as P

# TODO(policy): implement both. `insert(xs, y)` returns `xs` with `y` inserted,
# assuming `xs` is sorted; `isort(xs)` sorts `xs` by inserting its elements
# into the sorted tail. Both recurse on `xs`. `P.le`, `P.sorted_put`,
# `P.is_sorted` and `P.insert_put` are the prelude's and are immutable.
def insert(xs: List<&2, Nat>, +y: Nat) -> List<&2, Nat>:
  ?TODO

def isort(xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
