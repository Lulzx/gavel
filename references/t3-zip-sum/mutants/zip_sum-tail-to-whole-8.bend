import Base

# The reference solution: step on the first list and then on the second, so the
# recursion stops at whichever one runs out first.
def zip_sum(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h1 <> t1:
      match ys:
        case Nil{}:
          Nil{}
        case h2 <> t2:
          (h1 + h2) <> zip_sum(t1, ys)
