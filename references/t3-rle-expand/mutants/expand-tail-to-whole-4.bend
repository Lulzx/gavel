import Base
import ./prelude.bend as P

def expand(rs: List<&2, P.Run>) -> List<&2, Nat>:
  match rs:
    case Nil{}:
      Nil{}
    case P.Mk{v, k} <> t:
      P.append(P.repeat(v, k), expand(rs))
