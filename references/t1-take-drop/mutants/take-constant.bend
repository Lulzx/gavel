import Base
import ./prelude.bend as P

# Wrong: ignores `xs` and `n` and returns the empty list.
def take(xs: List<Nat>, n: Nat) -> List<Nat>:
  Nil{}
