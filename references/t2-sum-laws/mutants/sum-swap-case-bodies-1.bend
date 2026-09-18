import Base

def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      h + sum(t)

    case h <> t:
      0n
