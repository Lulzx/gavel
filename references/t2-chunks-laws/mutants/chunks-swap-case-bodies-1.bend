import Base
import ./prelude.bend as P

def chunks_go(xs: List<&2, Nat>, +n: Nat, k: Nat, cur: List<&2, Nat>, out: List<&2, List<&2, Nat>>) -> List<&2, List<&2, Nat>>:
  match xs:
    case Nil{}:
      P.push(out, cur)
    case h <> t:
      match k:
        case 0n:
          chunks_go(t, n, Nat.sub(n, 1n), h <> Nil{}, P.push(out, cur))
        case 1n++j:
          chunks_go(t, n, j, P.snoc(cur, h), out)

def chunks(xs: List<&2, Nat>, +n: Nat) -> List<&2, List<&2, Nat>>:
  match xs:
    case Nil{}:
      match n:
        case 0n:
          Nil{}
        case 1n++j:
          chunks_go(t, n, Nat.sub(n, 1n), h <> Nil{}, Nil{})

    case h <> t:
      Nil{}
