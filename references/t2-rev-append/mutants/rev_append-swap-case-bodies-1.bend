import Base

def rev_append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      rev_append(t, h <> ys)

    case h <> t:
      ys
