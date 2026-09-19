Implement `assoc_delete` on association lists, then prove the four laws about
it.

An association list is a `List<&2, P.Entry>`, and `P.Entry` is the prelude's
`Mk{k: Nat, v: Nat}` -- a key and the value stored under it. `assoc_delete(k,
kvs)` removes the *first* entry of `kvs` whose key is `k` and keeps every other
entry exactly as it was, in the order it was in: `assoc_delete(2n, [Mk{1n, 7n},
Mk{2n, 8n}, Mk{2n, 9n}])` is `[Mk{1n, 7n}, Mk{2n, 9n}]`. If no entry carries
`k`, the whole association list comes back. Recurse on `kvs`: the empty list has
no entry to remove, and a cons cell compares its key with `k` and either answers
its tail, dropping the entry whole, or keeps its entry in front of the removal
from the tail.

`P.key_select(a, b, x, y)` is the comparison and the decision in one: it answers
`x` when the two keys are the same and `y` otherwise, by a structural descent on
both numbers. It is a def rather than a `match` in the body for a reason of the
checker rather than of taste: **a `match` cannot scrutinise a computed
comparison**, so a cons step that needs two different answers picked by a
comparison it just made is not a thing you can write inline. Both answers are
association lists, so the step can either drop its entry or keep it.

The law `assoc_delete_nil` fixes the answer when the list runs out. It is
definitional, and it is the law that says the removal does not *insert* -- a body
that consed an entry onto the front does not have its two sides equal.

The law `assoc_delete_step` is the unfolding of a cons cell, and `P.key_select`
is the whole of the comparison in it. It is stuck where the two keys are the
same variable, so it constrains the decision only for keys the descent can take
a step on; the two laws below are what pin the two cases it cannot reach.

The law `assoc_delete_hit` is the one that says *first*: an entry carrying the
query is removed whole, and the answer is the tail as it stands -- not the tail
with anything further taken out of it, even when the tail carries the same key
again. The law's left-hand side cannot step the comparison on its own, so its
proof needs a fact about `P.key_select` -- it is its own first answer when both
keys are the same variable, by induction on that variable -- and a def stating
such a fact goes under the reserved `Policy.` namespace, which the gate ignores.

The law `assoc_delete_skip` is the other half of the comparison: an entry whose
key is one more than the query is kept as it stands, both components of it, and
the removal continues in the tail. Together with `assoc_delete_hit` it says the
comparison is an equality and not an order -- a body that dropped the entry of
every key *at least* the query passes the hit law and fails this one.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.assoc_delete_nil(k)`, `def L.assoc_delete_step(hk, hv, k, t)`,
`def L.assoc_delete_hit(w, kvs, k)` and `def L.assoc_delete_skip(w, kvs, k)`.
