import Base
import ./prelude.bend as P

def zip3(xs: List<Nat>, ys: List<Nat>, zs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h1 <> t1:
      match ys:
        case Nil{}:
          Nil{}
        case h2 <> t2:
          match zs:
            case Nil{}:
              Nil{}
            case h3 <> t3:
              (h1 + h2 + h3) <> zip3(xs, t2, t3)
