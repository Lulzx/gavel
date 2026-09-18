import Base

def map_add(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      +k = n
      (h + k) <> map_add(t, k)

    case h <> t:
      Nil{}
