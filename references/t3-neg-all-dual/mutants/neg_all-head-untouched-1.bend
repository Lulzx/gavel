import Base
import ./prelude.bend as P

# The negation is applied and then the tail is left alone: the recursion is
# gone, so the answer is the head's negation followed by the argument's tail.
def neg_all(xs: List<&2, Bool>) -> List<&2, Bool>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      Bool.not(h) <> t
