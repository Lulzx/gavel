import Base
import ./prelude.bend as P

# The reference solution: step on the list and compare the head with the target.
# The comparison is decided by `P.eq` and taken by `P.at_if`, which matches on
# the value it is handed -- a match cannot scrutinise a computed value where it
# is written, so the decision is passed on rather than taken here. A hit answers
# the tail outright, and that is what removes the first occurrence; a miss keeps
# the head in front of the removal from the tail.
def delete(+x: Nat, xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> +t:
      P.at_if(P.eq(x, h), t, h <> delete(x, t))
