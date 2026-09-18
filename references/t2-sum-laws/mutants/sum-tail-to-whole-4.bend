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
      0n
    case h <> t:
      h + sum(xs)
