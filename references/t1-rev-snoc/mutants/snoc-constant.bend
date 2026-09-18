import Base

# Wrong: ignores `xs` and `x` and returns the empty list. Both sides of the law
# are then not `x <> reverse(xs)`.
def snoc(xs: List<Nat>, x: Nat) -> List<Nat>:
  Nil{}
