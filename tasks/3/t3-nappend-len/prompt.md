Implement `nappend` on the prelude's `List<&2, Nat>`, then prove all three laws.

`nappend(xs, n)` is `xs` repeated `n` times and concatenated: `nappend(xs, 0n)` is
the empty list and `nappend(xs, 1n + p)` is `xs` followed by `nappend(xs, p)`.
The prelude is immutable and already has the vocabulary the laws are stated in:
`P.append`, and `P.len`. `List<&2, Nat>` is the list type here, and a law or
helper written over `List<Nat>` will not unify with these.

The two pins are definitional. `nappend_zero` fixes what repeating a list zero
times means, and `nappend_succ` fixes one step of the repetition. Both sides of
each compute, so `{==}` closes them, and the reason they are worth stating is
that they are what says the answer is built by *concatenating*: a body that
answered `xs` on every successor agrees with the value law below on a one-element
list and leaves the two sides of `nappend_succ` unconvertible.

The real work is `nappend_len`, and its step needs a fact the prelude does not
have: the length of an `append` is the sum of the lengths. That fact is not
definitional, because `append` matches on its *first* argument, so with a
variable list the goal is stuck until something inducts on that list. So the task
carries two inductions -- one on the list for the length of an append, one on `n`
for the repetition -- and neither can be replaced by unfolding.

The repetition induction is the easy one, and it is worth seeing why: `n` counts
down and `xs` is carried unchanged, so the hypothesis lands exactly where the
step needs it and no generalization is required. The list lemma is the one that
needs a helper of its own, and inside its step the goal has to be regrouped from
`1n + (P.len(t) + P.len(ys))` into `(1n + P.len(t)) + P.len(ys)`. `Nat.add`
matches on its *left* argument, so that regrouping is not definitional either and
the proof needs associativity as a second helper.

A variable is Lone by default -- usable live once per branch -- and both the
solution and the helper mark `xs` with `+`, because each uses the list twice: the
helper in `P.append` and in its recursive call, the solution in the same two
places. In a pattern the same marker is written on the binder itself, as in
`case 1n++p:`, which is the pattern form of a `+` parameter; a variable bound by
a pattern without it is consumed by its first use.

The helpers belong under the reserved `Policy.` namespace, which the gate ignores
and the credit path does not count. A helper may call `P.*`, `S.*` and other
`Policy.*`, but never a law, since a helper that cited one would make an isolated
law depend on a law that has not been credited yet and the credit for both would
be lost. Their parameters are mostly erased (`-b`, `-c`) because each step uses
them only in the goal; the ones that are live twice carry `+` instead.

The direction of every rewrite is the one that matters. A rewrite `%e : P` fills
the hole in the motive `P` at the position of the *right* side of `e`'s equation
and puts the left side there, so `P` is the goal with the hole exactly where the
term you want to replace sits. A lemma stated the other way round has to be
flipped first: `Equal.sym(T, X, Y, e)` takes `e : {X == Y}` and gives `{Y == X}`,
so a lemma whose left side is the term already in the goal is exactly the case
that needs the flip, and a lemma already pointing the way you need is used bare.
A motive with the hole anywhere else is rejected with `expected`/`observed` about
the hole's type, which reads like a bug in the lemma and is not one.

The law file imports the prelude as `P` and the solution as `S`, and the solution
does not re-export the prelude, so the implementation must say `P.append`; naming
`append` gets `expected : a defined name / observed : append`, which also reads
like a proof bug and is not one.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.nappend_zero(xs)`, `def L.nappend_succ(xs, p)` and
`def L.nappend_len(xs, n)`, and each may cite the earlier helpers but never one
of the other laws. Write the implementation in `solution.bend` and the proofs in
`PROOF.bend`.
