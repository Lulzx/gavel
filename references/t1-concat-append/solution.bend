import Base
import ./prelude.bend as P

def concat(xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case a <> rest:
      P.append(a, concat(rest))
