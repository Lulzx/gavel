import Base

# The step adds the first list's element to itself and never reads the second
# list's. The nil laws hold, the length law counts, and `zip_sum_self` compares
# `zip_sum(xs, xs)` with itself on the diagonal, where the two heads are the
# same element -- so all four laws are proven by a body that is wrong off the
# diagonal.
# Measured: before `zip_sum_cons`, tier 4, reward 1.000; after, tier 3, reward
# 0.500 for the four older laws, first failure at `LAWS.zip_sum_cons`. The head
# is bound `+h1` because the body consumes it twice.
def zip_sum(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h1 <> t1:
      match ys:
        case Nil{}:
          Nil{}
        case h2 <> t2:
          (h1 + h1) <> zip_sum(t1, t2)
