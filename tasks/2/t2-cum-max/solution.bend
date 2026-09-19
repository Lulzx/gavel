import Base
import ./prelude.bend as P

# TODO(policy): implement both. `cum_max(xs)` is the list of the largest element
# seen so far at each position, so it is exactly as long as its input:
#
#   cum_max([3n, 1n, 2n])  ==  3n <> (3n <> (3n <> Nil{}))
#   cum_max([1n, 2n, 3n])  ==  1n <> (2n <> (3n <> Nil{}))
#   cum_max([7n])          ==  7n <> Nil{}
#   cum_max(Nil{})         ==  Nil{}
#
# `max_all(ys, m)` is the raise the walk is built out of: every element of `ys`
# replaced by the larger of it and `m`, so it is as long as `ys`.
#
# The walk runs from the *end* of the list back to the front: a non-empty list
# answers its head, followed by the running maxima of its *tail* raised by that
# head. There is no running value threaded as a parameter and no seed -- the head
# is the seed -- so the recursion is on the tail alone and the suffix is computed
# before the head is folded into it.
#
# In `max_all` the number the suffix is raised by is read once per cell, so it is
# declared reusable: `+m`. In `cum_max` the head is read twice -- once as the
# first entry of the answer and once as the raise -- so it is declared reusable:
# `+h`.
def max_all(ys: List<&2, Nat>, m: Nat) -> List<&2, Nat>:
  ?TODO

def cum_max(xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
