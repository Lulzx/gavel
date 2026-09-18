import Base
import ./prelude.bend as P

# Wrong: counts every element instead of the zeroes. The law rules this out
# because its right-hand side is `... + is_zero(x)`, which is stuck on a
# variable `x`, while a length grows by `1n` whatever the element is.
def Policy.len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + Policy.len(t)

def count_zeros(xs: List<Nat>) -> Nat:
  Policy.len(xs)
