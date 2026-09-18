import Base
import ./prelude.bend as P

# The empty list is answered with a one-element list. `sq_all_single` rejects it
# -- the body's answer at `h <> Nil{}` is `P.sq(h) <> (1n <> Nil{})` where the
# law wants `P.sq(h) <> Nil{}` -- and `sq_all_append` rejects it too, since it
# needs `sq_all(Nil{})` to be `Nil{}`.
def sq_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      1n <> Nil{}
    case h <> t:
      P.sq(h) <> sq_all(t)
