import Base
import ./prelude.bend as P

# The empty list is answered with a one-element list, so the base case leaks an
# extra element into every answer. `reverse_single` rejects it -- the body
# answers `1n <> (h <> Nil{})` where the law wants `h <> Nil{}` -- and
# `reverse_snoc` rejects it too, since its base case needs `reverse(Nil{})` to be
# `Nil{}`.
def reverse(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      1n <> Nil{}
    case h <> t:
      P.append(reverse(t), h <> Nil{})
