import Base
import ./prelude.bend as P

def count_key(kvs: List<&2, P.Entry>, +k: Nat) -> Nat:
  match kvs:
    case Nil{}:
      P.key_select(hk, k, 1n + count_key(t, k), count_key(t, k))

    case P.Mk{hk, hv} <> +t:
      0n
