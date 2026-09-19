import Base
import ./prelude.bend as P

def map_len(xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case l <> t:
      P.len(l) <> map_len(t)

def longest_row(xss: List<&2, List<&2, Nat>>) -> Nat:
  match xss:
    case Nil{}:
      0n
