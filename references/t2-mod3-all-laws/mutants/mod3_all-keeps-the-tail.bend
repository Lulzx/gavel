import Base
import ./prelude.bend as P

# The reduced head is consed onto the *unreduced* tail: a plausible slip when
# the recursion is written out of order, since the head gets `P.mod3` and the
# rest do not. `mod3_all_single` holds -- at `h <> Nil{}` the tail is already
# `Nil{}`, so the body's answer is `P.mod3(h) <> Nil{}` -- and it is
# `mod3_all_append` that rejects it, at the cons step: the elements of the tail
# are reduced on the law's side and untouched on the body's.
def mod3_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.mod3(h) <> t
