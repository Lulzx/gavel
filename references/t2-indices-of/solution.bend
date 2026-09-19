import Base
import ./prelude.bend as P

# The reference solution: step on the list and compare the head with the target.
# The comparison is decided by `P.eq` and taken by `P.cons_if`, which matches on
# the value it is handed -- a match cannot scrutinise a computed value where it
# is written, so the decision is passed on rather than taken here. A hit
# contributes its own position, `0n`, in front of the tail's positions; a miss
# contributes nothing of its own. Either way the tail's positions are shifted up
# by one, because every one of them sits one place further along than it did in
# the tail, and that shift is what makes the answer ascend.
def indices_of(xs: List<Nat>, +k: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.cons_if(P.eq(h, k), 0n, P.inc_all(indices_of(t, k)))
