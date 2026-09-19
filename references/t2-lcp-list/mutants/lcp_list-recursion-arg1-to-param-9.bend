import Base
import ./prelude.bend as P

def lcp_list(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      match ys:
        case Nil{}:
          Nil{}
        case k <> u:
          P.gate_list(P.is_eq(h, k), h <> lcp_list(t, xs))
