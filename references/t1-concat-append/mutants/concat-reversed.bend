import Base
import ./prelude.bend as P

# Wrong: appends the head *after* the concatenation of the tail, so the inner
# lists come back in the opposite order.
def concat(xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case a <> rest:
      P.append(concat(rest), a)
