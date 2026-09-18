import Base
import ./prelude.bend as P

# The head is put back unreduced: the recursion runs over the tail but nothing is
# ever stepped back. `pred_all_single` rejects it -- at `h <> Nil{}` the body
# answers `h <> Nil{}` where the law wants `P.pred(h) <> Nil{}` -- and
# `pred_all_append` rejects it too, since the tail's elements come out unreduced
# at every step.
def pred_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> pred_all(t)
