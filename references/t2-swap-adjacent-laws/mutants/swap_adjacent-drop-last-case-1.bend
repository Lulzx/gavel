import Base
import ./prelude.bend as P

def swap_adjacent(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
