import Base
import ./prelude.bend as P

# Wrong: answers the sum of the elements instead of the number of zeroes -- the
# neighbouring function that counts rather than measures. The law's right-hand
# side is `count_zeros(xs) + is_zero(x)`, which a sum does not grow by, and its
# left-hand side is stuck on the element `x` exactly as the count is.
def count_zeros(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + count_zeros(t)
