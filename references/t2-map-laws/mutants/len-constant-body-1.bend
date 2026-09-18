import Base

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      0n

def map(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      (1n+h) <> map(t)
