import Base

# Wrong: keeps the head of every cell, so it appends the new element but loses
# the rest.
def snoc(xs: List<Nat>, x: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      x <> Nil{}
    case h <> t:
      h <> snoc(Nil{}, x)
