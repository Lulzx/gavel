import Base
import ./prelude.bend as P

def insert_row(r: List<&2, Nat>, cols: List<&2, List<&2, Nat>>) -> List<&2, List<&2, Nat>>:
  match r:
    case Nil{}:
      cols
    case h <> t:
      match cols:
        case Nil{}:
          (h <> c) <> insert_row(t, cs)

        case c <> cs:
          (h <> Nil{}) <> insert_row(t, Nil{})

def transpose(rows: List<&2, List<&2, Nat>>) -> List<&2, List<&2, Nat>>:
  match rows:
    case Nil{}:
      Nil{}
    case r <> rs:
      insert_row(r, transpose(rs))
