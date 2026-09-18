import Base

# The reference solution: a fold over the list, so the empty list sums to the
# zero that `P.replicate` also produces at count zero.
def sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      h + sum(t)

    case h <> t:
      0n
