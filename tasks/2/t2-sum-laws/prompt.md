Implement `add` on `Nat` and `append` and `sum` on lists of `Nat`, then prove
both laws.

`add(a, b)` must return the sum of `a` and `b`; recurse on the first argument.
`append(xs, ys)` must return the elements of `xs` followed by the elements of
`ys`; recurse on `xs`. `sum(xs)` must return the total of the elements of `xs`;
recurse on `xs`, adding the head to the sum of the tail.

These lists are unrestricted (`List<&2, Nat>`) rather than the linear
`List<Nat>`: the step case of `sum_append` has to name the tail of `xs` and
`ys` more than once, and a linear list may only be named once.

`sum_append` says the sum of an append is the sum of the sums; it is inductive
in `xs`, and its step case needs associativity of `add` as a helper.
`sum_single` says the sum of a one-element list is that element; `sum` computes
it to `add(h, 0n)`, so that proof needs the fact that `add(h, 0n)` is `h`.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`,
as `def L.sum_append(xs, ys)` and `def L.sum_single(h)`.
