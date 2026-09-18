import Base
import ./prelude.bend as P

def zip(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, P.P2>:
  match xs:
    case Nil{}:
      match ys:
        case Nil{}:
          Nil{}
        case hy <> ty:
          P.Mk{hx, hy} <> zip(tx, ty)

    case hx <> tx:
      Nil{}
