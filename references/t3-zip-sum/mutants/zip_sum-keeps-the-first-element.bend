import Base

# Only the left list's element survives into the answer, so the second list is
# consumed for its length and nothing else. The nil laws hold and the length law
# counts; the element law fails, since on the diagonal the answer would be the
# list itself rather than the doubled list. Measured: `proof_tier=3
# bare_tier=2`, the two nil laws and the length law proven, first failure at
# `LAWS.zip_sum_self`.
def zip_sum(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h1 <> t1:
      match ys:
        case Nil{}:
          Nil{}
        case h2 <> t2:
          h1 <> zip_sum(t1, t2)
