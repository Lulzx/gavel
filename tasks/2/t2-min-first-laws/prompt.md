Implement `min_first`, the comparison-driven step of selection sort, then prove
all six laws.

`min_first(xs)` answers the elements of `xs` with the smallest one moved to the
front; everything else keeps its order. `min_first([3n, 1n, 2n])` is
`[1n, 3n, 2n]`. The empty list has no smallest element to move, so
`min_first(Nil{})` is `Nil{}`, and a one-element list is already its own answer.

The list type is `List<&2, Nat>`, and a law or helper written over `List<Nat>`
will not unify with these. The prelude is immutable and already has the
vocabulary the laws are stated in: `P.le(a, b)` is the `Bool` comparison,
`P.len(xs)` counts the elements, and `P.mf_put(h, r)` is the cons step with the
decision deferred to `P.mf_dec`. That pair is there because of a Bend
restriction rather than for convenience: **a `match` cannot scrutinise a
computed value**, so the cons case cannot decide inline on how the head
compares with the front of the tail's own answer. It hands the head and that
answer to `P.mf_put`, which is where the comparison lives.

`min_first` recurses on `xs`: `Nil{}` answers `Nil{}` and a cons cell answers
`P.mf_put(h, min_first(t))`. The recursion is on the tail of the list it
matched, so it is structural.

`min_first_nil` fixes the empty answer and `min_first_single` the one-element
one. Both sides compute in each, so both are definitional and both are pins.
`min_first_single` is the one that catches a walk seeded with a constant rather
than with the head.

`min_first_cons` says the cons case is `P.mf_put` of the head and the tail's own
answer. It is definitional, and it is the law that ties the two levels together:
a body that recursed on the wrong list, or that answered without recursing at
all, leaves the two sides unconvertible.

`min_first_keep` and `min_first_swap` are the two answers the comparison can
give, each stated on a literal two-element list so that the comparison is the
only thing left. `keep` says two elements the comparison already puts in order
come back unchanged; `swap` says the other value of the comparison puts them the
other way round. These two are the laws that observe *order* rather than
cardinality: with the comparison fixed they say which of the two elements ends
up first, so a body that answered some permutation of the argument without
looking at `P.le` is separated here even when it preserves the length. Each
carries the comparison as a premise, because with `x` and `y` variables
`P.le(x, y)` is stuck, and the premise is about the prelude's own predicate over
universally quantified values.

Be aware of the division of labour: because `min_first_cons` is definitional, a
body that gets the cons case right already satisfies `keep` and `swap` on any
concrete comparison the premise supplies. Their independent weight is against a
body that special-cases where the comparison leads; the case-by-case evidence
for the order laws comes from the mutants, not from an independent induction.

`min_first_len` is the work, and the one law that is not an unfolding: the
answer has as many elements as the argument, so the step consumed the tail
rather than stopping early or duplicating. With a variable list neither side
reduces, so this is an induction on `xs`. Its step needs one fact the prelude
does not state -- what `P.mf_put` does to a length, which is a case split on its
two arguments and needs no induction of its own. That fact goes in under the
reserved `Policy.` namespace, which the gate ignores, and it may not cite a law:
a helper that did would make an isolated law depend on a law that has not been
credited yet, and the credit for both would be lost.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.min_first_nil()`, `def L.min_first_single(x)`,
`def L.min_first_cons(h, t)`, `def L.min_first_keep(x, y, e)`,
`def L.min_first_swap(x, y, e)` and `def L.min_first_len(xs)`.
