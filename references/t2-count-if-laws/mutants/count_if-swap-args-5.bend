import Base
import ./prelude.bend as P

def count_if(ps: List<&2, P.Pair>) -> Nat:
  match ps:
    case Nil{}:
      0n
    case P.MkPair{a, b} <> t:
      P.same(b, a) + count_if(t)
