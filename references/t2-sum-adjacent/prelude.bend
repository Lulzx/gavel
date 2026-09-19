import Base

# Immutable, and owned by the task rather than the policy. `sum_adjacent` is
# what the policy writes; the length below is the vocabulary the count law is
# stated in, and it is here because the answer's elements are the sums and the
# input's elements are the addends, so a length that does not look inside them
# is the only thing the two shapes have in common.

# How many elements a list has.
def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
