import Base
import ./prelude.bend as P

def map_len(xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  match xss:
    case Nil{}:
      Nil{}

def longest_row(xss: List<&2, List<&2, Nat>>) -> Nat:
  match xss:
    case Nil{}:
      0n
    case l <> t:
      P.max(P.len(l), longest_row(t))
