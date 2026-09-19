import Base
import ./prelude.bend as P

# The reference solution: the match is on the list, so that each element is
# repeated in place. The empty list has nothing to repeat and answers the empty
# list; a cons repeats its head `n` times and puts the copies of its tail after
# them. `n` is read twice on that path -- once for the head's copies and once
# again for the tail's -- so it is declared reusably, and the list is the
# argument the recursion shrinks, which is why it comes first.
def replicate_each(xs: List<&2, Nat>, +n: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      P.append(P.rep(h, n), replicate_each(t, n))

    case h <> t:
      Nil{}
