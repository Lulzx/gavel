import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on the list; nothing to exchange answers the
# empty list, and a one-element list answers the same one-element list. A list
# of two or more answers its second element in front of its first, in front of
# the swaps of everything from the third element on. The match has to follow the
# parameter order: the list is matched first, and the tail is matched again
# inside the non-empty case to tell the one-element list from the rest.
def swap_adjacent(xs: List<Nat>) -> List<Nat>:
  ?TODO
