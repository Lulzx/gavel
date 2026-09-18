import Base

# The base case forgets the accumulator and answers `0n`, so the elements the
# recursion added on the way down are thrown away at the end. `sum_acc_single`
# rejects it -- at `h <> Nil{}` the body answers `0n` where the law wants `h` --
# and `sum_acc_append` rejects it too, since the accumulator is lost whichever
# way the list is split.
def sum_acc(xs: List<Nat>, acc: Nat) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      sum_acc(t, h + acc)
