import Base
import ./prelude.bend as P

# The walk. It carries the largest element it has seen so far and the position
# of that element, plus the position of the element it is about to look at. A
# cons cell folds its head into both running values: the head becomes the
# largest if it beats the largest seen so far, and the position follows the
# comparison rather than the value -- `P.gt` and not `P.ge`, so a head that
# merely ties with the largest seen so far leaves the position where it is. That
# is what makes the answer the first position of the largest element rather than
# the last. When the list runs out the answer is the position of the largest
# seen, not the position counter.
def argmax_go(xs: List<&2, Nat>, +cur: Nat, bi: Nat, +i: Nat) -> Nat:
  match xs:
    case Nil{}:
      bi
    case +h <> t:
      argmax_go(t, P.max2(h, cur), P.pick_if(P.gt(h, cur), i, bi), 1n + i)

# `argmax` is the walk over the tail of a cons cell with the head as the largest
# seen so far, `0n` as its position, and `1n` as the position the tail starts
# at. The empty list never reaches the walk.
def argmax(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      argmax_go(t, h, 0n, 1n)

    case h <> t:
      0n
