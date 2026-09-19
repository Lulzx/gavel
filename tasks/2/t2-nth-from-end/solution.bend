import Base
import ./prelude.bend as P

# TODO(policy): implement. `nth_from_end(xs, k, d)` is the element `k` positions
# from the end of `xs`, counting the last element as `0` positions from the end,
# or the default `d` when `xs` has no such element:
#
#   nth_from_end([1n, 2n, 3n], 0n, 9n)  ==  3n
#   nth_from_end([1n, 2n, 3n], 1n, 9n)  ==  2n
#   nth_from_end([1n, 2n, 3n], 3n, 9n)  ==  9n
#
# The list is the argument that shrinks, and in Bend the shrinking argument has
# to come before the arguments that are only read, so the list comes first.
def nth_from_end(xs: List<&2, Nat>, +k: Nat, +d: Nat) -> Nat:
  ?TODO

# TODO(policy): note the shape the laws are stated over. `P.len(t)` is the number
# of elements in the tail, so the head of a list whose tail has `k` elements is
# the element that is `k` positions from the end. The test is the prelude's
# `P.eq` and the decision is taken by `P.pick_if`, which matches on the value it
# is handed -- a match cannot scrutinise a computed value in place, so the test
# is passed to `P.pick_if` rather than matched on here. The default is answered
# when the walk runs off the front of the list, which is the case its empty arm
# is. The prelude also has `P.snoc` and `P.same`, which the laws about an element
# at a known distance from the end are written over; the walk itself does not use
# them.
