import Base

# The length of a list of numbers. It is here because one law about each of the
# two functions below reads the *number* of elements an answer holds rather than
# the elements themselves, and the length of a list is not something a `match` on
# an answer can produce: the law has to compare the answer against a count, and
# this is the count.
def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
