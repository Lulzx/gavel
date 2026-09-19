Implement `del_min`, the removal half of a selection step, then prove all five
laws.

`del_min(xs)` answers the elements of `xs` with one occurrence of the smallest
one removed; everything else keeps its order. `del_min([3n, 1n, 2n])` is
`[3n, 2n]`. The empty list has no smallest element to remove, so
`del_min(Nil{})` is `Nil{}`, and removing the smallest element of a one-element
list leaves `Nil{}`.

The list type is `List<&2, Nat>`, and a law or helper written over `List<Nat>`
will not unify with these. The prelude is immutable and already has the
vocabulary the laws are stated in: `P.le(a, b)` is the `Bool` comparison,
`P.len(xs)` counts the elements, `P.min_go(h <> t, h)` is the smallest element
of a non-empty list, and `P.dm_put(h, t, r)` is the cons step with the decision
deferred to `P.dm_dec`. That pair is there because of a Bend restriction rather
than for convenience: **a `match` cannot scrutinise a computed value**, so the
cons case cannot decide inline on how the head compares with the smallest
element of the tail's own answer. It hands the head and the tail to `P.dm_put`,
which is where the comparison lives.

`del_min` recurses on `xs`: `Nil{}` answers `Nil{}` and a cons cell answers
`P.dm_put(h, t, del_min(t))`. The recursion is on the tail of the list it
matched, so it is structural.

`del_min_nil` fixes the empty answer and `del_min_single` the one-element one.
Both sides compute in each, so both are definitional and both are pins.
`del_min_single` is the one that catches a walk seeded with a constant rather
than with the head.

`del_min_keep` and `del_min_drop` are the two answers the comparison can give,
stated on a three-element list so that the tail is a variable in both. `keep`
says that when the head is no larger than the smallest element behind it the
answer is the tail, unchanged -- the head was the minimum and is the element
removed. `drop` says the other value of the comparison keeps the head and
removes the minimum from the tail. Each carries the comparison as a premise,
because with `h` and `t` variables `P.le` is stuck, and the premise is about the
prelude's own predicate over universally quantified values.

Be aware of the division of labour: because `del_min_keep` and `del_min_drop`
are the two branches of the prelude's `P.dm_dec` with the premise supplied, a
body that gets the cons case right already satisfies them. Their independent
weight is against a body that special-cases where the comparison leads; the
case-by-case evidence for them comes from the mutants, not from an independent
induction.

`del_min_len` is the work, and the one law that is not an unfolding: removing
one element from a non-empty list leaves as many as the tail, so the step
consumed the tail rather than stopping early or duplicating. With a variable
list neither side reduces, so this is an induction on `t` with `h` universally
quantified. Its step needs one fact the prelude does not state -- what
`P.dm_put` does to a length when the part it replaces has the length of the
tail, which is a case split on the decision and needs the length of the tail's
own answer. That fact goes in under the reserved `Policy.` namespace, which the
gate ignores, and it may not cite a law: a helper that did would make an
isolated law depend on a law that has not been credited yet, and the credit for
both would be lost.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.del_min_nil()`, `def L.del_min_single(x)`, `def L.del_min_keep(x, y, t,
e)`, `def L.del_min_drop(x, y, t, e)` and `def L.del_min_len(h, t)`.
