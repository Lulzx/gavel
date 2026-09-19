import Base
import ./prelude.bend as P

# The reference solution: one pass. The head is expanded with `P.expand` and
# appended to the concatenation of the tail, so nothing is ever built as a list
# of lists the way the composition law's `P.map_expand` builds it.
def concat_map(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.append(P.expand(h), concat_map(xs))
