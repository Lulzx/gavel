import Base
import ./prelude.bend as P

# TODO(policy): implement. `row(x, ys)` is `x` paired with every element of
# `ys`, in the order `ys` has them: `[MkPair{x, y0}, MkPair{x, y1}, ...]`. The
# list is the argument that shrinks and it comes first in the walk's own
# recursion; `x` is read once per cell and once more on the recursive call, so
# it is declared reusable.
def row(+x: Nat, ys: List<&2, Nat>) -> List<&2, P.Pair>:
  ?TODO

# TODO(policy): implement. `cross(xs, ys)` is every element of `xs` paired with
# every element of `ys`: the rows in the order `xs` has them, and inside a row
# the pairs in the order `ys` has them. `ys` is read by every row, so it is
# declared reusable.
def cross(xs: List<&2, Nat>, +ys: List<&2, Nat>) -> List<&2, P.Pair>:
  ?TODO
