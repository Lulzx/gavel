import Base
import ./prelude.bend as P

# TODO(policy): implement. `max_gap(xs)` is the largest distance between two
# *adjacent* elements of `xs`, and `0n` when there are fewer than two elements:
#
#   max_gap([3n, 1n, 5n, 2n])  ==  3n        -- the gaps are 2n, 4n, 3n
#   max_gap([7n])              ==  0n
#
# The list is the argument that shrinks, so it comes first. `gap_go(xs, prev,
# best)` walks `xs` carrying the element before the window (`prev`) and the
# largest distance seen so far (`best`), and answers `best` when the list runs
# out. The head is compared with `P.absdiff` and folded into `best` with
# `Nat.max` -- the maximum is taken as the walk goes, so no list of differences
# is ever built. `max_gap` itself only opens the walk: the first element has
# nothing before it, so the walk starts there with nothing seen yet.
#
# In the walk the head is read twice -- once for the distance and once as the
# element before the next window -- so it is declared reusable: `+h`.
def gap_go(xs: List<&2, Nat>, prev: Nat, best: Nat) -> Nat:
  ?TODO

def max_gap(xs: List<&2, Nat>) -> Nat:
  ?TODO
