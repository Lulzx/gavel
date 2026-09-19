import Base
import ./prelude.bend as P

# TODO(policy): implement both. `extremes(xs)` answers the smallest and the
# largest element of `xs` as a two-element list, smallest first, and `Nil{}` for
# `Nil{}`. `ext_go(xs, lo, hi)` is the same walk from the pair of running values
# `lo` and `hi`: the empty list answers `lo <> hi <> Nil{}`, and a cons cell
# folds its head into both running values with `P.min2` and `P.max2` and recurses
# on the tail. `extremes` starts the walk at the head, read twice, which is why
# the list is `List<&2, Nat>` here as in `t2-span-below`.
def ext_go(xs: List<&2, Nat>, lo: Nat, hi: Nat) -> List<&2, Nat>:
  ?TODO

def extremes(xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
