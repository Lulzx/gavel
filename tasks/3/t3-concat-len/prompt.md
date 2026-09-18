Implement `concat` on lists of lists, then prove all three laws.

`concat(xss)` flattens a `List<List<Nat>>` into a `List<Nat>`: the pieces end to
end, in order, nothing dropped and nothing repeated. It folds the element-type
`append` over the pieces, so it recurses on `xss` and its cons step is
`P.append(h, concat(t))`.

The prelude is immutable and already has the vocabulary: `P.append`, `P.len`,
`P.sum`, `P.sum_lens` and `P.sum_sums`. The last two are measures of a list of
lists, and they are the flattening counted without flattening it:
`P.sum_lens(xss)` adds up the lengths of the pieces and `P.sum_sums(xss)` adds
up their sums, each matching on `xss` and folding a piece at a time. The first
says how many elements `concat` is going to produce; the second says which ones,
by value rather than by count. They are there so that the laws can speak about
`concat` without naming the list it builds -- a statement about the flattened
answer would have to mention `concat` on both sides and could not be checked one
step at a time.

`concat_len` says the flattened list has as many elements as the pieces have
between them, `concat_sum` says it holds the same elements as they do, and
`concat_single` says a list of one piece is that piece. The first two are
inductions on `xss`, and their step cases are the whole task. Both fold a measure
over an `append` whose right side is the flattened tail: the goal becomes
`len(append(h, concat(t)))` against `len(h) + sum_lens(t)`, and the list sitting
under the measure, `concat(t)`, is one the induction hypothesis already describes
but that nothing here can match on -- `append` matches on its first argument, and
its second is opaque, so the fold does not compute. The measure has to be pulled
over that `append` by a lemma of its own, proved by the same induction one level
down at the element type: measuring `P.append(xs, ys)` gives the measure of `xs`
plus the measure of `ys`, which is the form in which the append's own structure
is available to the outer induction.

So the measures need the two standard facts about the prelude's `append`: that
`Nil{}` is its right identity -- `concat_single` unfolds to `append(xs, Nil{})`,
and that is the whole of it -- and the reassociation by which a measure passes
over an `append`, which is the associativity-shaped fact and is proved the same
way, by induction on the first argument. The natural-number facts underneath are
one-level-up reassociations of `+` in the same shape: the base case computes to
the same term on both sides, and the step case is the hypothesis at the
predecessor with the same operation on the outside.

The direction of each rewrite is the one that matters: to replace a term `O` in
the goal you supply a proof of `{R == O}` with `R` the term you want, which is
`Equal.sym` around a lemma that points the other way. A definitional equality is
closed with `{==}`, and there is no `Equal.refl`. A `match` must come before the
rewrites that mention its binders, and a rewrite that mentions a variable before
the `match` on it will not be accepted.

Write the implementation in `solution.bend` and the proof in `PROOF.bend`, as
`def L.concat_len(xss)`, then `def L.concat_sum(xss)`, then
`def L.concat_single(xs)` -- in that order. Any helpers they need go under the
reserved `Policy.` namespace, which the gate ignores, and none of them may cite a
law: a helper that did would make an isolated law depend on a law that has not
been credited yet, and the credit for both would be lost.
