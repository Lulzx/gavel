Implement `append` and `sum` on lists of `Nat`, then prove both laws.

`append(xs, ys)` must return the elements of `xs` followed by the elements of
`ys`; recurse on `xs`. `sum(xs)` must return the total of the elements of `xs`;
recurse on `xs`, adding the head to the sum of the tail.

`sum_append` says the sum of an append is the sum of the sums; it is inductive
in `xs`, and its step case needs the associativity of `+` to move the head past
the two sums -- `+` is stuck on a variable head, so that reassociation is a
lemma of its own, under the reserved `Policy.` namespace.

`sum_single` says the sum of a one-element list is that element. `sum` computes
it to `h + 0n`, so that proof needs the fact that adding zero on the right is
the identity, also as a `Policy.` lemma.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`,
as `def L.sum_append(xs, ys)` and `def L.sum_single(h)`.
