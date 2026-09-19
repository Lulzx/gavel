import Base
import ./prelude.bend as P

def diffs(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      match t:
        case Nil{}:
          Nil{}
        case +h2 <> t2:
          P.sub(h2, h) <> diffs(h2 <> t2)

    case h <> t:
      Nil{}
