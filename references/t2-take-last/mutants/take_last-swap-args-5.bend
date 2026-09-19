import Base
import ./prelude.bend as P

def take_last(xs: List<&2, Nat>, +k: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> +t:
      P.keep_if(P.le(P.len(h <> t), k), h <> t, take_last(k, t))
