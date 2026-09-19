import Base
import ./prelude.bend as P

def swap_adjacent(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case x <> t:
      match t:
        case Nil{}:
          y <> (x <> swap_adjacent(t2))

        case y <> t2:
          x <> Nil{}
