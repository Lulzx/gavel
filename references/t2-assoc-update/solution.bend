import Base
import ./prelude.bend as P

def assoc_update(kvs: List<&2, P.Entry>, +k: Nat, +v: Nat) -> List<&2, P.Entry>:
  match kvs:
    case Nil{}:
      Nil{}
    case P.Mk{+hk, hv} <> +t:
      P.key_select(hk, k, P.Mk{k, v} <> t, P.Mk{hk, hv} <> assoc_update(t, k, v))
