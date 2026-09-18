import Base
import ./prelude.bend as P

# A plausible out-of-order slip: the head is stepped back and the tail is consed
# back whole. `pred_all_single` holds -- at `h <> Nil{}` the tail is already
# `Nil{}` -- and `pred_all_append` rejects it at the cons step, where the law's
# side steps the tail's elements back and the body does not.
def pred_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.pred(h) <> t
