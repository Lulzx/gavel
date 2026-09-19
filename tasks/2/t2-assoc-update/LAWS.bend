import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: updating a key the empty association list does not carry changes nothing.
# It is definitional, and it is the weak half: it fixes what an update answers
# when there is nothing to change, and it is also the law that says the update
# does not *insert* -- a body that consed the new pair onto the front leaves the
# two sides here unconvertible.
law update_nil:
  for k: Nat
  for v: Nat
  {S.assoc_update(Nil{}, k, v) == Nil{} : List<&2, P.Entry>}

# LAW: the step. A cons cell answers the list with its own value replaced when
# its key is the query and otherwise keeps its entry in front of the update of
# its tail, and the prelude's `key_select` is the whole of the comparison. This
# is the law that pins the decision at *every* pair of keys -- the two value laws
# below reach only pairs that differ by one, and a body whose comparison is wrong
# somewhere else satisfies both of them.
law update_cons:
  for hk: Nat
  for hv: Nat
  for kvs: List<&2, P.Entry>
  for k: Nat
  for v: Nat
  {S.assoc_update(P.Mk{hk, hv} <> kvs, k, v) == P.key_select(hk, k, P.Mk{k, v} <> kvs, P.Mk{hk, hv} <> S.assoc_update(kvs, k, v)) : List<&2, P.Entry>}

# LAW: an entry found by its own key has its value replaced, the rest of the
# association list is untouched, and the entry does not move. It is the law that
# pins *which* component is written: a body that stored `P.Mk{v, k}` satisfies
# `update_nil` and leaves the two sides here unconvertible as soon as the value
# is not the key.
law update_hit:
  for w: Nat
  for kvs: List<&2, P.Entry>
  for k: Nat
  for v: Nat
  {S.assoc_update(P.Mk{k, w} <> kvs, k, v) == P.Mk{k, v} <> kvs : List<&2, P.Entry>}

# LAW: an entry whose key is one more than the query is kept as it stands, and
# the update continues in the tail. It is not a definitional unfolding -- the
# comparison is a descent on the keys, not on the list -- and together with
# `update_hit` it says the comparison is an equality and not an order: a body
# that overwrote the value of every entry whose key was *at least* the query
# satisfies `update_hit` and leaves the two sides here unconvertible.
law update_skip:
  for w: Nat
  for kvs: List<&2, P.Entry>
  for k: Nat
  for v: Nat
  {S.assoc_update(P.Mk{1n + k, w} <> kvs, k, v) == P.Mk{1n + k, w} <> S.assoc_update(kvs, k, v) : List<&2, P.Entry>}
