import Base
import ./prelude.bend as P

def windows_go(ys: List<&2, Nat>, +k: Nat, +xs: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  match ys:
    case Nil{}:
      Nil{}

def windows(+k: Nat, +xs: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  match k:
    case 0n:
      Nil{}
    case 1n+p:
      windows_go(P.lookahead(xs, k), k, xs)
