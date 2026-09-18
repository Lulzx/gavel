import Base
import ./prelude.bend as P

# The head goes onto the *right* of the reversed tail, through the prelude's
# `snoc`: that is what makes every law's step an induction instead of a
# computation, since `snoc` matches on its first argument and the first argument
# here is the opaque `rev(t)`.
def rev(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.snoc(rev(t), h)
