Implement `concat_map` on a list of `Nat`, then prove all four laws.

`concat_map(xs)` is the map and the flatten in one pass: every element of `xs`
becomes a two-element list and the results are concatenated. The prelude fixes
what one element becomes -- `P.expand(x)` is `x` followed by its successor, so
`concat_map([2n, 5n])` is `[2n, 3n, 5n, 6n]`. Recurse on `xs`: `Nil{}` answers
`Nil{}`, and `h <> t` appends `P.expand(h)` to the concatenation of `t`.
`P.append` comes from the prelude.

The prelude is immutable and already has the vocabulary the laws are stated in:
`P.expand`, the list one element becomes; `P.append`, the appending of two
lists; `P.concat`, which flattens a list of lists; `P.map_expand`, which maps
`expand` over a list; `P.len`, the length of a list of `Nat`; and `P.elen`, the
length every answer must have -- two elements for every element of the input,
written out as its own recurrence rather than as a multiplication.

`concat_map_nil` pins the empty input: nothing expands, so nothing comes back.
It is the answer the step law below never reaches, since that one names
`h <> t`.

`concat_map_cons` is the step, and it is definitional: the head becomes
`P.expand(h)` and the answer is that appended to the recursion on the tail. It
is the law that says which list the head becomes.

`concat_map_concat` is the composition law, and the only one that relates the
target to the prelude's fixed functions rather than to itself: one pass is
`P.concat` after `P.map_expand`. It is an induction on `xs`, and it is the law
that catches a body which agrees with the step but builds the answer as a list
of lists and flattens it afterwards in the wrong order.

`concat_map_len` is the count half, and it is stated without mentioning
`P.concat`, `P.map_expand` or `P.append` at all: every element contributes
exactly two, so the answer is as long as `P.elen` says. A body that emitted the
wrong number of elements is caught here even when it agrees with the
composition.

Together the laws determine the body: `concat_map_cons` reads it on a cons
cell, `concat_map_nil` on the empty list, and the two inductions are what say
that the recursion is the one the step law describes all the way down.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.concat_map_nil()`, `def L.concat_map_cons(h, t)`,
`def L.concat_map_concat(xs)` and `def L.concat_map_len(xs)`.
