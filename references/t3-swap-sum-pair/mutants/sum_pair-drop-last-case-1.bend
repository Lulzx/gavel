import Base
import ./prelude.bend as P

def swap_each(ps: List<&2, P.Pair>) -> List<&2, P.Pair>:
  match ps:
    case Nil{}:
      Nil{}
    case P.MkPair{a, b} <> t:
      P.MkPair{b, a} <> swap_each(t)

def sum_pair(ps: List<&2, P.Pair>) -> Nat:
  match ps:
    case Nil{}:
      0n
