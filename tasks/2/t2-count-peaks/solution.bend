import Base
import ./prelude.bend as P

# TODO(policy): implement. `count_peaks(xs)` is how many elements of `xs` are
# strictly greater than *both* of their neighbours. An element with only one
# neighbour is not a peak, so a list of fewer than three elements has none, and
# neither the first nor the last element of a longer list is ever counted.
def count_peaks(xs: List<&2, Nat>) -> Nat:
  ?TODO

# TODO(policy): implement. The walk. `t` is what is left to read, `prev` is the
# element before the element in hand, and `h` is the element whose peak status
# is being decided by the element that comes next. `h` is read twice -- once
# into `P.peak_at` and once as the element before the next window -- so it is
# declared reusable, and so is the element the match takes off the front of `t`,
# which is read twice for the same reason. The list comes first because it is
# the argument that shrinks.
def peaks_go(t: List<&2, Nat>, prev: Nat, +h: Nat) -> Nat:
  ?TODO
