import Base

# The list is walked and the accumulator is threaded through, but the head is
# never added to it, so the answer is the accumulator the list started with.
# `sum_acc_single` rejects it -- at `h <> Nil{}` the body answers `0n` where the
# law wants `h` -- and `sum_acc_append` rejects it too, since the elements of
# neither piece reach the accumulator.
def sum_acc(xs: List<Nat>, acc: Nat) -> Nat:
  match xs:
    case Nil{}:
      acc
    case h <> t:
      sum_acc(t, acc)
