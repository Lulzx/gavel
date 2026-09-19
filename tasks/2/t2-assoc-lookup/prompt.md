Implement `assoc_lookup` on association lists, then prove the four laws about
it. An association list is a list of the prelude's `P.Entry`, a pair of a key and
the value stored under it; the constructors are reached through the prelude
alias, `P.Mk{k, v}`, in patterns and in terms alike, and Bend has no tuples,
which is why the pair is a type of its own.

`assoc_lookup(kvs, k)` must answer the value stored under `k`, or `0n` when no
entry carries that key. Recurse on `kvs`: `Nil{}` returns `0n`, and a cons cell
answers its own value when its key is `k` and otherwise defers to the lookup in
its tail. The comparison is the prelude's `P.key_select(a, b, x, y)`, which is
`x` when `a` and `b` are the same key and `y` otherwise: a `match` cannot
scrutinise a computed comparison, so the comparison is a function of its own, and
the call is `P.key_select(hk, k, hv, assoc_lookup(t, k))`. Because `k` is read
once for the comparison and once for the recursive call, it has to be a `+`
parameter.

The law `lookup_nil` is the weak half. It fixes what an empty association list
answers, and both sides compute, so it closes by direct computation.

The law `lookup_cons` is the step, and it is the law that pins the comparison at
*every* pair of keys: the two value laws below reach only pairs that differ by
one, and a body whose comparison is wrong somewhere else satisfies both of them.
It is definitional -- the match steps on the cons cell and both sides are the
same `key_select`.

The law `lookup_hit` says an entry found by its own key answers its own value,
whatever is behind it and whatever the value is. It is the law that pins which
component of the pair the answer comes from: a body that answered the *key*
satisfies `lookup_nil` and leaves the two sides here unconvertible as soon as the
value is not the key.

The law `lookup_skip` says an entry whose key is one more than the query is
skipped and the search continues in the tail. It is not a definitional
unfolding, because the comparison is a descent on the *keys* rather than on the
list, and it is worth stating beside `lookup_hit`: together they say the
comparison is an equality and not an order. A body whose head wins whenever its
key is *at least* the query satisfies `lookup_hit` and leaves the two sides here
unconvertible. The proof of this one is an induction on the query, not on the
list -- the list does not change under it.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.lookup_nil(k)`, `def L.lookup_cons(hk, hv, kvs, k)`,
`def L.lookup_hit(v, kvs, k)` and `def L.lookup_skip(v, kvs, k)`. The two facts
about `key_select` that `lookup_hit` and `lookup_skip` need are yours to state
and prove, under the reserved `Policy.` namespace.
