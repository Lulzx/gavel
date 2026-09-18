import Base
import ./prelude.bend as P

def interleave(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case hx <> tx:
      match ys:
        case Nil{}:
          hx <> hy <> interleave(tx, ty)

        case hy <> ty:
          hx <> tx
