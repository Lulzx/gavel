import Base

def init(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      match t:
        case Nil{}:
          Nil{}
        case h2 <> t2:
          h <> init(h2 <> t2)
