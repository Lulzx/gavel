import Base
import ./prelude.bend as P

def pred_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
