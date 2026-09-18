import Base
import ./prelude.bend as P

# The empty list is answered by a one-element list: the cons case is the
# reference's, so only the base law can see this.
def neg_all(xs: List<&2, Bool>) -> List<&2, Bool>:
  match xs:
    case Nil{}:
      True{} <> Nil{}
    case h <> t:
      Bool.not(h) <> neg_all(t)
