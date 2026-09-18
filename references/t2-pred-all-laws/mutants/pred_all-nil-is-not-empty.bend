import Base
import ./prelude.bend as P

# The empty list is answered with a one-element list, the "never hand back
# nothing" slip. `pred_all_single` rejects it -- the body's answer at `h <> Nil{}`
# is `P.pred(h) <> (1n <> Nil{})` where the law wants `P.pred(h) <> Nil{}` -- and
# `pred_all_append` rejects it too, since it needs `pred_all(Nil{})` to be `Nil{}`.
def pred_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      1n <> Nil{}
    case h <> t:
      P.pred(h) <> pred_all(t)
