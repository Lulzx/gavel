import Base
import ./prelude.bend as P

# TODO(policy): implement. `argmax(xs)` is the position of the largest element
# of `xs`, counting from `0n`, and on a tie the *first* such position:
#
#   argmax([1n, 3n, 2n])        ==  1n
#   argmax([2n, 3n, 3n, 1n])    ==  1n
#   argmax([7n])                ==  0n
#
# The list is never empty when this is called; the empty list answers `0n`
# anyway. A cons cell hands its tail to the walk with the head as the largest
# seen so far and `0n` as its position, which is the only place the walk is
# started.
def argmax(xs: List<&2, Nat>) -> Nat:
  ?TODO

# TODO(policy): implement. `argmax_go(xs, cur, bi, i)` walks `xs` carrying the
# largest element seen so far, `cur`; the position of that element in the whole
# list, `bi`; and the position of the element it is about to look at, `i`. The
# empty list answers `bi` -- everything has been seen. A cons cell folds its
# head in and recurses on the tail: the new largest is `P.max2(h, cur)`, and the
# new position is `i` when the head is strictly greater than `cur` and `bi` when
# it is not, which is what keeps the *first* of equal elements. The comparison
# is `P.gt(h, cur)` and the decision is taken by `P.pick_if`, which matches on
# the value it is handed: a match cannot scrutinise a computed value in place,
# so the comparison is passed on rather than taken here. `cur` and `i` are read
# twice in the step and `h` is read twice, so they are declared reusable.
def argmax_go(xs: List<&2, Nat>, +cur: Nat, bi: Nat, +i: Nat) -> Nat:
  ?TODO
