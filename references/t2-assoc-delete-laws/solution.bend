import Base
import ./prelude.bend as P

# The reference solution: step on the association list and compare the entry's
# key with the query. The comparison is decided by `P.key_select`, which is a
# def because a match cannot scrutinise a computed comparison -- the decision is
# passed on rather than taken here. A hit answers the tail outright, and that is
# what removes the first entry carrying the key; a miss keeps the entry whole in
# front of the removal from the tail.
def assoc_delete(+k: Nat, kvs: List<&2, P.Entry>) -> List<&2, P.Entry>:
  match kvs:
    case Nil{}:
      Nil{}
    case P.Mk{+hk, hv} <> +t:
      P.key_select(hk, k, t, P.Mk{hk, hv} <> assoc_delete(k, t))
