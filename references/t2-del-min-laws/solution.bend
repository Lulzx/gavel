import Base
import ./prelude.bend as P

def del_min(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> +t:
      P.dm_put(h, t, del_min(t))
