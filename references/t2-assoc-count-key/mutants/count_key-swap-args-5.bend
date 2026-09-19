import Base
import ./prelude.bend as P

def count_key(kvs: List<&2, P.Entry>, +k: Nat) -> Nat:
  match kvs:
    case Nil{}:
      0n
    case P.Mk{hk, hv} <> +t:
      P.key_select(hk, k, 1n + count_key(k, t), count_key(t, k))
