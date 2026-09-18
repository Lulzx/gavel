import Base
import ./prelude.bend as P

# Wrong: returns `xs` unchanged, which reverses nothing.
def reverse(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> t
