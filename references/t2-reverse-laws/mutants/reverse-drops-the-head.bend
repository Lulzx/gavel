import Base
import ./prelude.bend as P

# The cons case drops the head and keeps the recursion, so the answer is the
# reversed tail and one element goes missing per step. `reverse_single` rejects
# it -- its left-hand side reduces to `Nil{}` where the law wants
# `h <> Nil{}` -- and `reverse_snoc` rejects it too.
def reverse(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      reverse(t)
