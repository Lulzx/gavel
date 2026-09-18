import Base
import ./prelude.bend as P

def pred_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      P.pred(h) <> pred_all(t)

    case h <> t:
      Nil{}
