import Base
import ./prelude.bend as P

def inc_bin(bs: List<&2, P.Bit>) -> List<&2, P.Bit>:
  match bs:
    case Nil{}:
      P.I{} <> Nil{}
    case h <> t:
      match h:
        case P.O{}:
          P.I{} <> bs
        case P.I{}:
          P.O{} <> inc_bin(bs)
