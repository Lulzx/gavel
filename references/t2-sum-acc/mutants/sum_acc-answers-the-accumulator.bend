import Base

# The body is its accumulator in both cases, which is the degenerate answer the
# law's comment names: the list is matched on and never read. `sum_acc_single`
# rejects it -- at `h <> Nil{}` the body answers `0n` where the law wants `h` --
# and `sum_acc_append` rejects it too, since both of its sides are then the
# accumulator, but for different splits.
def sum_acc(xs: List<Nat>, acc: Nat) -> Nat:
  match xs:
    case Nil{}:
      acc
    case h <> t:
      acc
