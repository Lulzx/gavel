import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty association list carries no key, so there is no entry to
# remove. It is definitional, and it is a pin: it fixes the answer when there is
# nothing to look at, and it is the law that says the removal does not *insert*
# -- a body that consed an entry onto the front leaves the two sides here
# unconvertible.
law assoc_delete_nil:
  for k: Nat
  {S.assoc_delete(k, Nil{}) == Nil{} : List<&2, P.Entry>}

# LAW: the step. A cons cell answers the list without its own entry when its key
# is the query and otherwise keeps its entry whole in front of the removal from
# its tail, and the prelude's `key_select` is the whole of the comparison. This
# is the law that pins the decision at *every* pair of keys -- the two laws
# below reach only the pairs that differ by one and the pairs that are equal --
# and it is stuck where the two keys are the same variable, which is what the
# hit law below is for.
law assoc_delete_step:
  for hk: Nat
  for hv: Nat
  for k: Nat
  for +t: List<&2, P.Entry>
  {S.assoc_delete(k, P.Mk{hk, hv} <> t) == P.key_select(hk, k, t, P.Mk{hk, hv} <> S.assoc_delete(k, t)) : List<&2, P.Entry>}

# LAW: an entry carrying the query is removed whole -- the answer is the tail as
# it stands, and not the tail with anything further taken out of it, even when
# the tail carries the same key again. This is the law that says *first*
# occurrence and not every one, and it is the only law here that reads a hit:
# `assoc_delete_step` is stated at a variable key pair, so on its own it never
# unfolds a comparison.
law assoc_delete_hit:
  for w: Nat
  for kvs: List<&2, P.Entry>
  for k: Nat
  {S.assoc_delete(k, P.Mk{k, w} <> kvs) == kvs : List<&2, P.Entry>}

# LAW: an entry whose key is one more than the query is kept as it stands, both
# components of it, and the removal continues in the tail. It is not a
# definitional unfolding -- the comparison is a descent on the keys, not on the
# list -- and together with `assoc_delete_hit` it says the comparison is an
# equality and not an order: a body that dropped the entry of every key that was
# at *least* the query satisfies `assoc_delete_hit` and leaves the two sides
# here unconvertible.
law assoc_delete_skip:
  for w: Nat
  for kvs: List<&2, P.Entry>
  for k: Nat
  {S.assoc_delete(k, P.Mk{1n + k, w} <> kvs) == P.Mk{1n + k, w} <> S.assoc_delete(k, kvs) : List<&2, P.Entry>}
