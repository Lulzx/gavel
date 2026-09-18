import Base

def snoc(xs: List<Nat>, x: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      h <> snoc(t, x)

    case h <> t:
      x <> Nil{}
