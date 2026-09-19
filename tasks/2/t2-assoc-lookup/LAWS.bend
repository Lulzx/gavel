import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: looking up a key in the empty association list answers `0n`. It is
# definitional, and it is the weak half: it fixes what `assoc_lookup` answers
# when there is nothing to search.
law lookup_nil:
  for k: Nat
  {S.assoc_lookup(Nil{}, k) == 0n : Nat}

# LAW: the step. A cons cell answers its own value when its key is the query and
# the tail's answer otherwise, and the prelude's `key_select` is the whole of the
# comparison. This is the law that pins the decision at *every* pair of keys --
# the two value laws below reach only the pairs that differ by one, and a body
# whose comparison is wrong somewhere else satisfies both of them.
law lookup_cons:
  for hk: Nat
  for hv: Nat
  for kvs: List<&2, P.Entry>
  for k: Nat
  {S.assoc_lookup(P.Mk{hk, hv} <> kvs, k) == P.key_select(hk, k, hv, S.assoc_lookup(kvs, k)) : Nat}

# LAW: an entry found by its own key answers its own value, whatever is behind it
# and whatever the value is. This is the law that pins which component of the
# pair the answer comes from: a body that answered the *key* satisfies
# `lookup_nil` and leaves the two sides here unconvertible as soon as `v` is not
# `k`.
law lookup_hit:
  for v: Nat
  for kvs: List<&2, P.Entry>
  for k: Nat
  {S.assoc_lookup(P.Mk{k, v} <> kvs, k) == v : Nat}

# LAW: an entry whose key is one more than the query is skipped, and the search
# continues in the tail. It is not a definitional unfolding -- the comparison is
# a descent on the keys, not on the list -- and together with `lookup_hit` it
# says the comparison is an equality and not an order: a body whose head wins
# whenever its key is *at least* the query satisfies `lookup_hit` and leaves the
# two sides here unconvertible.
law lookup_skip:
  for v: Nat
  for kvs: List<&2, P.Entry>
  for k: Nat
  {S.assoc_lookup(P.Mk{1n + k, v} <> kvs, k) == S.assoc_lookup(kvs, k) : Nat}
