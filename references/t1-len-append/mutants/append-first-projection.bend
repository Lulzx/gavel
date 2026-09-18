import Base

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  xs
