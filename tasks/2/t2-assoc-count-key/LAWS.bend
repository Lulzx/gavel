import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: no entry of the empty association list carries any key. It is
# definitional, and it is the weak half: it fixes what the count answers when
# there is nothing to count.
law count_key_nil:
  for k: Nat
  {S.count_key(Nil{}, k) == 0n : Nat}

# LAW: the step. A cons cell adds one to its tail's count when its key is the
# query and adds nothing otherwise, and the prelude's `key_select` is the whole
# of the comparison. This is the law that pins the decision at *every* pair of
# keys -- the two value laws below reach only the pairs that differ by one, and
# a body whose comparison is wrong somewhere else satisfies both of them.
law count_key_cons:
  for hk: Nat
  for hv: Nat
  for kvs: List<&2, P.Entry>
  for k: Nat
  {S.count_key(P.Mk{hk, hv} <> kvs, k) == P.key_select(hk, k, 1n + S.count_key(kvs, k), S.count_key(kvs, k)) : Nat}

# LAW: an entry whose key is the query contributes one, whatever its value is.
# This is the law that pins which component of the pair the comparison reads: a
# body that compared the *value* against the query satisfies `count_key_nil` and
# leaves the two sides here unconvertible as soon as `v` is not `k`.
law count_key_hit:
  for v: Nat
  for kvs: List<&2, P.Entry>
  for k: Nat
  {S.count_key(P.Mk{k, v} <> kvs, k) == 1n + S.count_key(kvs, k) : Nat}

# LAW: an entry whose key is one more than the query contributes nothing. It is
# not a definitional unfolding -- the comparison is a descent on the keys, not on
# the list -- and together with `count_key_hit` it says the comparison is an
# equality and not an order: a body that counted an entry whenever its key was
# *at least* the query satisfies `count_key_hit` and leaves the two sides here
# unconvertible.
law count_key_skip:
  for v: Nat
  for kvs: List<&2, P.Entry>
  for k: Nat
  {S.count_key(P.Mk{1n + k, v} <> kvs, k) == S.count_key(kvs, k) : Nat}

# LAW: storing under a key raises that key's count by exactly one, and it is
# definitional -- the store puts the new entry at the front and the count reads
# the head of the result. It ties the count to the association list's structure
# rather than to the entry list it was handed.
law count_key_put:
  for kvs: List<&2, P.Entry>
  for k: Nat
  for v: Nat
  {S.count_key(P.assoc_put(kvs, k, v), k) == 1n + S.count_key(kvs, k) : Nat}
