import Base
import ./prelude.bend as P

def count_if(ps: List<&2, P.Pair>) -> Nat:
  match ps:
    case Nil{}:
      P.same(a, b) + count_if(t)

    case P.MkPair{a, b} <> t:
      0n
