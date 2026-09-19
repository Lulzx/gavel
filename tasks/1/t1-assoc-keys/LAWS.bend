import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: storing under a key puts the new entry at the front, unchanged. Both
# sides compute, so this one is definitional, and it is the law that says *which*
# component of the pair is the key the entry is stored under and which is the
# value: a `put` that built `P.Mk{v, k}` satisfies every law about `keys` that
# follows, because none of them ever looks at a value.
law put_cons:
  for kvs: List<&2, P.Entry>
  for k: Nat
  for v: Nat
  {S.assoc_put(kvs, k, v) == P.Mk{k, v} <> kvs : List<&2, P.Entry>}

# LAW: the empty association list has no keys. It is definitional, and it is the
# weak half: the constant body `Nil{}` satisfies it.
law keys_nil:
  {S.keys(Nil{}) == Nil{} : List<&2, Nat>}

# LAW: the keys of a cons cell are its own key in front of the keys of its tail.
# This is the law that pins `keys`: the constant body `Nil{}` satisfies
# `keys_nil` and leaves the two sides here unconvertible, and a body that
# collected the *values* -- `hv <> S.keys(kvs)` -- satisfies `keys_len` below
# and is killed here and nowhere else.
law keys_cons:
  for hk: Nat
  for hv: Nat
  for kvs: List<&2, P.Entry>
  {S.keys(P.Mk{hk, hv} <> kvs) == hk <> S.keys(kvs) : List<&2, Nat>}

# LAW: the two functions meet: storing under a key adds that key to the front of
# the key list. It is definitional -- `assoc_put` prepends and `keys` reads the
# head of the result -- and it is the law that ties the projection to the
# structure rather than to the entry list it was given.
law keys_put:
  for kvs: List<&2, P.Entry>
  for k: Nat
  for v: Nat
  {S.keys(S.assoc_put(kvs, k, v)) == k <> S.keys(kvs) : List<&2, Nat>}

# LAW: a projection does not change how many keys there are. It is inductive in
# `kvs`, and it is the law that says the entries are counted and not dropped: a
# body that answered only the first entry's key, or that stopped one entry
# early, satisfies neither this nor `keys_cons`, but a body that answered a
# list of the right length with the wrong numbers in it satisfies this one
# alone -- which is why `keys_cons` is beside it.
law keys_len:
  for kvs: List<&2, P.Entry>
  {P.len(S.keys(kvs)) == P.plen(kvs) : Nat}
