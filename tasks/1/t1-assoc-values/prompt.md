Implement `values` and `sum_values` on association lists, then prove the six
laws about them. An association list is a list of the prelude's `P.Entry`, a pair
of a key and the value stored under it; the constructors are reached through the
prelude alias, `P.Mk{k, v}`, in patterns and in terms alike, and Bend has no
tuples, which is why the pair is a type of its own.

`values(kvs)` must answer the list of the values stored in the association list,
in the order the entries occur, and `sum_values(kvs)` must answer their sum.
Recurse on `kvs`: `Nil{}` answers `Nil{}` and `0n` respectively, and a cons cell
projects its value onto the front of the projection of its tail, and adds its
value to the sum of its tail. The key is read by the pattern and is not used by
either function, so neither body needs a `+` parameter -- but a pattern binder
that is not used by the body is still a binder, so do not reach for the key as a
shorthand for anything.

The laws `values_nil` and `values_cons` are the two halves of the projection: the
first fixes what an empty association list projects to, and the second says a
cons cell projects its *value* -- not its key -- onto the projection of its tail.
Both are definitional. `values_cons` is the law that pins which component of the
pair is read: a body that projected the key satisfies `values_nil` and leaves the
two sides of `values_cons` unconvertible as soon as a value is not its key.

The law `values_put` is where the projection meets the association list's own
structure: storing under a key puts exactly that value at the front of the
projection, and the projection of the rest is untouched. It is definitional,
since the store puts the new entry at the head. Read beside `values_cons`, it
says the projection reads the *stored* value rather than echoing the query.

The laws `sum_values_nil` and `sum_values_cons` are the two halves of the sum,
and both are definitional: `Nil{}` sums to `0n`, and a cons cell adds its value
to the sum of its tail. `sum_values_cons` is the law that pins which component is
summed: a body that summed the keys satisfies `sum_values_nil` and leaves the two
sides of `sum_values_cons` unconvertible.

The law `sum_values_values` is the one that is not a definitional unfolding, and
it is why the task is worth its laws: it says that summing an association list
*is* summing its value projection, for every association list, not just for one
cell. The five laws above are each relative to what one step of one function
does; this one compares the two functions on a whole list, so a body that folds
the values in some other way -- right to left instead of left to right, or with a
base case that is not `0n` at a cell deeper than the first -- satisfies every one
of them and leaves the two sides here unconvertible. Prove it by induction on the
association list; the step needs the hypothesis at the tail, because the sum
descends on `List<&2, P.Entry>` and the projection hands it a `List<&2, Nat>` the
sum cannot see through.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.values_nil()`, `def L.values_cons(hk, hv, kvs)`, `def L.values_put(kvs, k,
v)`, `def L.sum_values_nil()`, `def L.sum_values_cons(hk, hv, kvs)` and
`def L.sum_values_values(kvs)`.
