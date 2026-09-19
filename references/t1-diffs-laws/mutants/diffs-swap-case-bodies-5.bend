import Base
import ./prelude.bend as P

def diffs(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      match t:
        case Nil{}:
          P.sub(h2, h) <> diffs(h2 <> t2)

        case +h2 <> t2:
          Nil{}
