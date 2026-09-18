import Base
import ./prelude.bend as P

# The classic wrong end: the head goes with the recursion, but it is consed back
# in front of it instead of appended at the end. `reverse_single` holds -- with
# an empty tail, front and end are the same place -- and `reverse_snoc` rejects
# it: the body's answer keeps the head first where the law moves the last element
# to the front.
def reverse(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> reverse(t)
