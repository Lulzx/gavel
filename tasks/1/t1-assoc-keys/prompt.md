Implement `assoc_put` and `keys` on association lists, then prove the five laws
that relate them. An association list is a list of the prelude's `P.Entry`, a
pair of a key and the value stored under it; the constructors are reached
through the prelude alias, `P.Mk{k, v}`, in patterns and in terms alike, and
Bend has no tuples, which is why the pair is a type of its own. `P.len` measures
a number list and `P.plen` measures an entry list.

`assoc_put(kvs, k, v)` must store `v` under `k` by putting the new entry at the
front of `kvs`, so that it is the entry a later reader meets first. It does not
walk the list: the answer is `P.Mk{k, v} <> kvs`.

`keys(kvs)` must collect the keys in the order the entries appear. Recurse on
`kvs`: `Nil{}` returns `Nil{}`, and a cons cell puts its own key in front of the
keys of its tail.

The law `put_cons` says that storing under a key puts the new entry at the
front, unchanged. It closes by direct computation, and it is the law that says
*which* component of the pair is the key: a `put` that built `P.Mk{v, k}`
satisfies every law about `keys`, because none of them ever looks at a value.

The law `keys_nil` is the weak companion that pins the base case. It is
definitional, and the constant body `Nil{}` satisfies it.

The law `keys_cons` pins `keys` itself. The constant body `Nil{}` satisfies
`keys_nil` and leaves the two sides here unconvertible, and a body that
collected the *values* -- answering `hv <> keys(kvs)` -- satisfies `keys_len`
and is killed here and nowhere else.

The law `keys_put` is where the two functions meet: storing under a key adds
that key to the front of the key list. It is definitional, and it ties the
projection to the structure rather than to the entry list it was given.

The law `keys_len` says a projection does not change how many keys there are.
It is inductive in `kvs`. A body that answered a list of the right length with
the wrong numbers in it satisfies this one alone, which is why `keys_cons` is
beside it.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.put_cons(kvs, k, v)`, `def L.keys_nil()`, `def L.keys_cons(hk, hv, kvs)`,
`def L.keys_put(kvs, k, v)` and `def L.keys_len(kvs)`.
