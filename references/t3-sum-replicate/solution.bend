import Base

# The reference solution: a fold over the list, so the empty list sums to the
# zero that `P.replicate` also produces at count zero.
def sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum(t)
