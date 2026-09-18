import Base
import ./prelude.bend as P

# Wrong: keeps every head in front, so the list comes back in its original
# order.
def reverse(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> reverse(t)
