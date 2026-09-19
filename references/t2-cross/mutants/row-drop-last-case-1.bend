import Base
import ./prelude.bend as P

def row(+x: Nat, ys: List<&2, Nat>) -> List<&2, P.Pair>:
  match ys:
    case Nil{}:
      Nil{}

def cross(xs: List<&2, Nat>, +ys: List<&2, Nat>) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      Nil{}
    case x <> t:
      P.append(row(x, ys), cross(t, ys))
