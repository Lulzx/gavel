import Base
import ./prelude.bend as P

def insert(xs: List<&2, Nat>, +y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      P.insert_put(t, h, y, P.le(y, h))

    case +h <> t:
      y <> Nil{}

def isort(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      insert(isort(t), h)
