import Base
import ./prelude.bend as P

def nappend(+xs: List<&2, Nat>, n: Nat) -> List<&2, Nat>:
  match n:
    case 0n:
      P.append(xs, nappend(xs, p))

    case 1n+p:
      Nil{}
