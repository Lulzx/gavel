import Base
import ./prelude.bend as P

def assoc_lookup(kvs: List<&2, P.Entry>, +k: Nat) -> Nat:
  match kvs:
    case Nil{}:
      P.key_select(hk, k, hv, assoc_lookup(t, k))

    case P.Mk{hk, hv} <> t:
      0n
