import Base
import ./prelude.bend as P

# Wrong: ignores `xs` and returns the empty list.
def reverse(xs: List<Nat>) -> List<Nat>:
  Nil{}
