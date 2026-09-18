import Base
import ./prelude.bend as P

def dup_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      +h2 = h
      h2 <> (h2 <> dup_all(t))

    case h <> t:
      Nil{}
