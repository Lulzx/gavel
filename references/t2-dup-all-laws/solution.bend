import Base
import ./prelude.bend as P

def dup_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +h2 = h
      h2 <> (h2 <> dup_all(t))
