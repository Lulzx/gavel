import Base
import ./prelude.bend as P

# The reference solution: step on the list and compare the head with the target.
# The comparison is decided by `P.eq` and taken by `P.at_if`, which matches on
# the value it is handed -- a match cannot scrutinise a computed value where it
# is written, so the decision is passed on rather than taken here. The position
# is counted by stepping the recursive answer by one on a miss, and the empty
# list answers `0n`, which is where the two counts meet: on a hit the position
# is `0n`, and when nothing is found the same zero is added to once per element,
# which is the length.
def index_of(xs: List<Nat>, +k: Nat) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.at_if(P.eq(h, k), 0n, 1n + index_of(xs, k))
