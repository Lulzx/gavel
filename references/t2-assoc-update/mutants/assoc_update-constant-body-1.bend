import Base
import ./prelude.bend as P

def assoc_update(kvs: List<&2, P.Entry>, +k: Nat, +v: Nat) -> List<&2, P.Entry>:
  match kvs:
    case Nil{}:
      Nil{}
    case P.Mk{+hk, hv} <> +t:
      Nil{}
