import Base
import ./prelude.bend as P

# The head is negated and the recursion is replaced by a fixed tail, so every
# non-empty argument maps to the same two-element list.
def neg_all(xs: List<&2, Bool>) -> List<&2, Bool>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      Bool.not(h) <> (False{} <> Nil{})
