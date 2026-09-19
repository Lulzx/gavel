import Base
import ./prelude.bend as P

def swap_adjacent(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case x <> t:
      match xs:
        case Nil{}:
          x <> Nil{}
        case y <> t2:
          y <> (x <> swap_adjacent(t2))
