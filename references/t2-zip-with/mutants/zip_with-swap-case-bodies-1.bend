import Base
import ./prelude.bend as P

# The reference solution: step on the first list and then on the second, so the
# recursion stops at whichever one runs out first, and combine the two heads
# with the prelude's operation.
def zip_with(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      match ys:
        case Nil{}:
          Nil{}
        case h2 <> t2:
          P.max(h1, h2) <> zip_with(t1, t2)

    case h1 <> t1:
      Nil{}
