import Base

# The head is added to the result of the recursion instead of to the
# accumulator. The two are the same function numerically -- addition commutes at
# the value level, so this is just `sum` written on top of an accumulator -- but
# `sum_acc_append` cannot discharge it: the checker stops in its cons step, whose
# hypothesis expects `h + acc` where the body keeps `h` outside the recursion.
# `sum_acc_single` does hold, which is why this body is caught by the append law
# alone.
def sum_acc(xs: List<Nat>, acc: Nat) -> Nat:
  match xs:
    case Nil{}:
      acc
    case h <> t:
      h + sum_acc(t, acc)
