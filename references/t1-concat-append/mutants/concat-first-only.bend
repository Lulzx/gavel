import Base
import ./prelude.bend as P

# Wrong: keeps only the first inner list, so the rest of the outer list is
# dropped.
def concat(xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case a <> rest:
      a
