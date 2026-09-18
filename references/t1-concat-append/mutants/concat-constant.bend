import Base
import ./prelude.bend as P

# Wrong: ignores the outer list and returns the empty list.
def concat(xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  Nil{}
