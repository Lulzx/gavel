import Base
import ./prelude.bend as P

def sum_adjacent(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      match t:
        case Nil{}:
          h + k <> sum_adjacent(k <> u)

        case +k <> u:
          Nil{}
