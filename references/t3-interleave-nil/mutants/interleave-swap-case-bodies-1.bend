import Base
import ./prelude.bend as P

def interleave(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      match ys:
        case Nil{}:
          hx <> tx
        case hy <> ty:
          hx <> hy <> interleave(tx, ty)

    case hx <> tx:
      ys
