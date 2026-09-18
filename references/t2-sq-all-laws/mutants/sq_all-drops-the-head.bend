import Base
import ./prelude.bend as P

# The cons case answers with the recursion alone, so the head is lost rather than
# squared. `sq_all_single` rejects it -- its left-hand side reduces to `Nil{}`
# where the law wants `P.sq(h) <> Nil{}` -- and `sq_all_append` rejects it too:
# the body's answer keeps the elements of the tail only.
def sq_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      sq_all(t)
