import Base
import ./prelude.bend as P

# Wrong: counts the head of the outer cell only, so everything after the first
# element is ignored.
def count_zeros(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.is_zero(h)
