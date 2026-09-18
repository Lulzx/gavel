import Base

# Wrong: returns `xs` unchanged, so nothing is added on the right.
def snoc(xs: List<Nat>, x: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> t
