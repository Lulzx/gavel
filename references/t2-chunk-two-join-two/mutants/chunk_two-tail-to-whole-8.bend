import Base
import ./prelude.bend as P

def chunk_two(xs: List<Nat>) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      Nil{}
    case x <> t:
      match t:
        case Nil{}:
          Nil{}
        case h <> t2:
          P.MkPair{x, h} <> chunk_two(t)

def join_two(ps: List<&2, P.Pair>) -> List<Nat>:
  match ps:
    case Nil{}:
      Nil{}
    case P.MkPair{a, b} <> t:
      a <> (b <> join_two(t))
