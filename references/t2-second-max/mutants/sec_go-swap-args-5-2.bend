import Base
import ./prelude.bend as P

# The walk. It carries the largest and the second largest element it has seen so
# far, and it answers the second of the two when the list runs out. A cons cell
# folds its head into both: the head becomes the largest if it beats the largest
# seen so far, and `P.min2(h, top)` is what the new second gets compared
# against, so a head below the largest replaces the second only when it is above
# it. The `0n` the walk starts from is below every element, so an element below
# the second never moves it.
def sec_go(xs: List<&2, Nat>, +top: Nat, second: Nat) -> Nat:
  match xs:
    case Nil{}:
      second
    case +h <> t:
      sec_go(t, P.max2(h, top), P.max2(P.min2(top, h), second))

# `second_max` is the walk over the tail of a cons cell with the head as the
# largest seen so far and nothing yet seen for the second slot. The empty list
# never reaches the walk.
def second_max(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      sec_go(t, h, 0n)
