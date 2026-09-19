import Base
import ./prelude.bend as P

def run_max(xs: List<Nat>, +m: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      P.max(h, m) <> run_max(t, P.max(m, h))
