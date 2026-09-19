Implement `index_of` on a list of `Nat`, then prove all four laws.

`index_of(xs, k)` is the position of the first element of `xs` that is `k`,
counting from `0n`, or the length of `xs` when `k` does not occur:

    index_of([5n, 7n, 6n], 6n)  ==  2n
    index_of([5n, 7n, 6n], 9n)  ==  3n

The second of those is the sentinel at work: the answer is one past the last
position, which is exactly `P.len(xs)`, so the search never has to say
"not found" any other way. Recurse on the list: `Nil{}` answers `0n` -- its own
length -- and a cons cell compares its head with the target and either answers
`0n` or steps the position of the rest on by one. The list is the argument that
shrinks, and in Bend the shrinking argument has to come before an argument that
is only read, so the list comes first and the target second.

The comparison is the prelude's `P.eq` and the decision is taken by `P.at_if`,
which matches on the value it is handed. A match cannot scrutinise a computed
value where it is written, so the comparison is passed to `P.at_if` rather than
matched on in place; that is the only reason the two definitions exist. The
target is read twice in the step, once into the comparison and once into the
recursive call, so it is declared reusably (`+k`).

The prelude is immutable and already has the vocabulary the laws are stated in:
`P.eq`, the comparison; `P.at_if`, the decision; `P.len`, the length of a list;
and `P.inc_all`, which steps every element up by one, so that a list it is
applied to has no `0n` in it at all.

`index_of_nil` pins the empty input. It is the only law whose left-hand side is
a closed list, and it fixes the answer there, which the step law below never
reaches.

`index_of_step` is the step, and it is definitional: the head is compared with
the target and the two answers are `0n` and one more than the position of the
target in the tail. It is the law that says the answer counts positions -- the
recursion steps by exactly one -- and that the head is the element compared.

`index_of_hit` is the found-at-head case: an element at the head is at position
`0n`, whatever the rest of the list is. The step law is stated for a variable
`k`, so it never unfolds a comparison on its own -- `P.eq(k, k)` is stuck where
the two arguments are the same variable -- and this is the law that says the
comparison decides `True{}` there.

`index_of_miss` is the not-found case, and it is what the sentinel is for.
Searching a list in which nothing is `0n` finds nothing, so the answer is the
length. This is the induction, and it fixes the sentinel's value: the step law
leaves the answer at the empty list free, and a body that answered any constant
there satisfies neither of the two laws above nor this one.

Together the laws determine the body: the empty list is fixed, the step says
what a cons cell becomes, the hit says the comparison is not reversed, and the
miss says the count is the length.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.index_of_nil(k)`, `def L.index_of_step(h, k, t)`, `def L.index_of_hit(k,
t)` and `def L.index_of_miss(xs)`.
