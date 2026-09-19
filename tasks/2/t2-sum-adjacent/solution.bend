import Base
import ./prelude.bend as P

# TODO(policy): implement. `sum_adjacent(xs)` is a list one element shorter than
# `xs`, whose entries are the sum of the first and second elements, then of the
# second and third, and so on. A list of fewer than two elements has no
# successive pair and answers the empty list.
#
# The walk moves along the list it matched: the element at the front of what is
# left is the second half of the pair just added and the first half of the next
# one, so it is read twice and is declared reusable.
def sum_adjacent(xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
