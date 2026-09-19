import Base
import ./prelude.bend as P

def diffs(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      match t:
        case Nil{}:
          Nil{}
        case +h2 <> t2:
          P.sub(h, h2) <> diffs(h2 <> t2)
