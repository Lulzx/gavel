import Base
import ./prelude.bend as P

# The reference solution: step on the list and compare the head with the target.
# The comparison is decided by `P.eq` and taken by `P.at_if`, which matches on
# the value it is handed -- a match cannot scrutinise a computed value where it
# is written, so the decision is passed on rather than taken here. On a hit the
# head's own position, `0n`, goes in front of the tail's positions shifted along
# by one; on a miss the shifted tail is the whole answer, which is what makes
# the positions count from the front.
def positions(+x: Nat, xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> +t:
      Nil{}
