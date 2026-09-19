import Base
import ./prelude.bend as P

def run_max(xs: List<Nat>, +m: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      P.max(m, h) <> run_max(t, P.max(m, h))

    case +h <> t:
      Nil{}
