import Base
import ./prelude.bend as P

# A plausible out-of-order slip: the head is squared and the tail is consed back
# whole. `sq_all_single` holds -- at `h <> Nil{}` the tail is already `Nil{}` --
# and `sq_all_append` rejects it at the cons step, where the law's side squares
# the tail's elements and the body does not.
def sq_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.sq(h) <> t
