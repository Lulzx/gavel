import Base
import ./prelude.bend as P

# The head is negated and the tail is dropped: the answer is a one-element list
# for every non-empty argument.
def neg_all(xs: List<&2, Bool>) -> List<&2, Bool>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      Bool.not(h) <> Nil{}
