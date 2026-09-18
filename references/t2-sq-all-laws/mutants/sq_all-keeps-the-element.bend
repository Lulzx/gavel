import Base
import ./prelude.bend as P

# The head is put back unsquared: the recursion runs over the tail but the head
# is never multiplied by itself. `sq_all_single` rejects it -- at `h <> Nil{}` the
# body answers `h <> Nil{}` where the law wants `P.sq(h) <> Nil{}` -- and
# `sq_all_append` rejects it too, since the tail's elements come out unsquared at
# every step.
def sq_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> sq_all(t)
