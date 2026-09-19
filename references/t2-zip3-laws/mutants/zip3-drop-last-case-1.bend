import Base
import ./prelude.bend as P

def zip3(xs: List<Nat>, ys: List<Nat>, zs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
