import Base
import ./prelude.bend as P

def nappend(+xs: List<&2, Nat>, n: Nat) -> List<&2, Nat>:
  match n:
    case 1n:
      Nil{}
    case 1n+p:
      P.append(xs, nappend(xs, p))
