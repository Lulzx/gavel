import Base

def sum_acc(xs: List<Nat>, acc: Nat) -> Nat:
  match xs:
    case Nil{}:
      acc
    case h <> t:
      sum_acc(t, h + acc)
