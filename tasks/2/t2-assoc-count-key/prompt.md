Implement `count_key` on association lists, then prove the five laws about it.
An association list is a list of the prelude's `P.Entry`, a pair of a key and the
value stored under it; the constructors are reached through the prelude alias,
`P.Mk{k, v}`, in patterns and in terms alike, and Bend has no tuples, which is
why the pair is a type of its own.

`count_key(kvs, k)` must answer how many entries carry the key `k`. Recurse on
`kvs`: `Nil{}` returns `0n`, and a cons cell adds one to the count for its tail
when its key is `k` and adds nothing otherwise. The comparison is the prelude's
`P.key_select(a, b, x, y)`, which is `x` when `a` and `b` are the same key and
`y` otherwise: a `match` cannot scrutinise a computed comparison, so the
comparison is a function of its own. The tail is counted in *both* branches of
that comparison and the query is read in both, so the tail and `k` have to be
`+` parameters.

The law `count_key_nil` is the weak half. It fixes what an empty association
list counts for, and both sides compute, so it closes by direct computation.

The law `count_key_cons` is the step, and it is the law that pins the comparison
at *every* pair of keys: the two value laws below reach only pairs that differ
by one, and a body whose comparison is wrong somewhere else satisfies both of
them. It is definitional -- the match steps on the cons cell and both sides are
the same `key_select`.

The law `count_key_hit` says an entry whose key is the query contributes one,
whatever its value is. It is the law that pins which component of the pair the
comparison reads: a body that compared the *value* against the query satisfies
`count_key_nil` and leaves the two sides here unconvertible as soon as the value
is not the key.

The law `count_key_skip` says an entry whose key is one more than the query
contributes nothing. It is not a definitional unfolding, because the comparison
is a descent on the *keys* rather than on the list, and it is worth stating
beside `count_key_hit`: together they say the comparison is an equality and not
an order. A body that counted an entry whenever its key was *at least* the query
satisfies `count_key_hit` and leaves the two sides here unconvertible.

The law `count_key_put` is where the count meets the association list's own
structure: storing under a key raises that key's count by exactly one. It is
definitional, since the store puts the new entry at the front and the count
reads the head of the result.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.count_key_nil(k)`, `def L.count_key_cons(hk, hv, kvs, k)`,
`def L.count_key_hit(v, kvs, k)`, `def L.count_key_skip(v, kvs, k)` and
`def L.count_key_put(kvs, k, v)`. The two facts about `key_select` that the hit
and skip laws need are yours to state and prove, under the reserved `Policy.`
namespace.
