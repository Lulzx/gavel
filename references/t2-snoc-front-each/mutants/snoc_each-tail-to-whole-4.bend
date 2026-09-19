import Base
import ./prelude.bend as P

def snoc_each(xss: List<&2, List<&2, Nat>>, +y: Nat) -> List<&2, List<&2, Nat>>:
  match xss:
    case Nil{}:
      Nil{}
    case l <> t:
      P.snoc(l, y) <> snoc_each(xss, y)

def front_each(xss: List<&2, List<&2, Nat>>, +y: Nat) -> List<&2, List<&2, Nat>>:
  match xss:
    case Nil{}:
      Nil{}
    case l <> t:
      (y <> l) <> front_each(t, y)
