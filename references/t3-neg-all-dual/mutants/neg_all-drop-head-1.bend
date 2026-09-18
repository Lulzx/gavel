import Base
import ./prelude.bend as P

# The head is dropped instead of negated, so the answer is a suffix of the
# argument.
def neg_all(xs: List<&2, Bool>) -> List<&2, Bool>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      neg_all(t)
