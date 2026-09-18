import Base
import ./prelude.bend as P

def concat(xss: List<List<Nat>>) -> List<Nat>:
  match xss:
    case Nil{}:
      Nil{}
