import Base
import ./prelude.bend as P

def values(kvs: List<&2, P.Entry>) -> List<&2, Nat>:
  match kvs:
    case Nil{}:
      Nil{}
    case P.Mk{hk, hv} <> t:
      hv <> values(t)

def sum_values(kvs: List<&2, P.Entry>) -> Nat:
  match kvs:
    case Nil{}:
      0n
    case P.Mk{hk, hv} <> t:
      0n
