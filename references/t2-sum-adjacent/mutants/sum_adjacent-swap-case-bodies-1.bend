import Base
import ./prelude.bend as P

def sum_adjacent(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      match t:
        case Nil{}:
          Nil{}
        case +k <> u:
          h + k <> sum_adjacent(k <> u)

    case +h <> t:
      Nil{}
