import Base
import ./prelude.bend as P

def assoc_put(kvs: List<&2, P.Entry>, k: Nat, v: Nat) -> List<&2, P.Entry>:
  P.Mk{k, v} <> kvs

def keys(kvs: List<&2, P.Entry>) -> List<&2, Nat>:
  match kvs:
    case Nil{}:
      Nil{}
    case P.Mk{hk, hv} <> t:
      hk <> keys(t)
