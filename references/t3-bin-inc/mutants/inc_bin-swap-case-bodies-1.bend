import Base
import ./prelude.bend as P

def inc_bin(bs: List<&2, P.Bit>) -> List<&2, P.Bit>:
  match bs:
    case Nil{}:
      match h:
        case P.O{}:
          P.I{} <> t
        case P.I{}:
          P.O{} <> inc_bin(t)

    case h <> t:
      P.I{} <> Nil{}
