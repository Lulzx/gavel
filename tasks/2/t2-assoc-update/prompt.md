Implement `assoc_update` on association lists, then prove the four laws about
it. An association list is a list of the prelude's `P.Entry`, a pair of a key and
the value stored under it; the constructors are reached through the prelude
alias, `P.Mk{k, v}`, in patterns and in terms alike, and Bend has no tuples,
which is why the pair is a type of its own.

`assoc_update(kvs, k, v)` must change the value stored under `k` to `v` and
leave every other entry alone. It does *not* insert: a key the association list
does not carry is a key nothing happens for, so `Nil{}` updates to `Nil{}`.
Recurse on `kvs`: a cons cell answers the list with its own value replaced when
its key is `k` and otherwise keeps its entry in front of the update of its tail.
The comparison is the prelude's `P.key_select(a, b, x, y)`, which is `x` when `a`
and `b` are the same key and `y` otherwise: a `match` cannot scrutinise a
computed comparison, so the comparison is a function of its own, and its two
answers here are lists. The query, the value and the tail are each read in both
branches of the comparison, and the head's key is read once for the comparison
and once for the entry that is kept, so all four have to be `+` parameters.

The law `update_nil` is the weak half, and it is the law that says the update
does not insert: it fixes what an update answers when there is nothing to change,
both sides compute, and a body that consed the new pair onto the front leaves
the two sides here unconvertible.

The law `update_cons` is the step, and it is the law that pins the comparison at
*every* pair of keys: the two value laws below reach only pairs that differ by
one, and a body whose comparison is wrong somewhere else satisfies both of them.
It is definitional -- the match steps on the cons cell and both sides are the
same `key_select`.

The law `update_hit` says an entry found by its own key has its value replaced,
the rest of the list is untouched, and the entry does not move. It is the law
that pins *which* component is written: a body that stored `P.Mk{v, k}`
satisfies `update_nil` and leaves the two sides here unconvertible as soon as
the value is not the key.

The law `update_skip` says an entry whose key is one more than the query is kept
as it stands and the update continues in the tail. It is not a definitional
unfolding, because the comparison is a descent on the *keys* rather than on the
list, and it is worth stating beside `update_hit`: together they say the
comparison is an equality and not an order. A body that overwrote the value of
every entry whose key was *at least* the query satisfies `update_hit` and leaves
the two sides here unconvertible.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.update_nil(k, v)`, `def L.update_cons(hk, hv, kvs, k, v)`,
`def L.update_hit(w, kvs, k, v)` and `def L.update_skip(w, kvs, k, v)`. The two
facts about `key_select` that the hit and skip laws need are yours to state and
prove, under the reserved `Policy.` namespace.
