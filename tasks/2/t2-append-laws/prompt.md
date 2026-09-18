Implement `add` on `Nat` and `append` and `len` on lists of `Nat`, then prove
both laws.

`add(a, b)` must return the sum of `a` and `b`; recurse on the first argument.
`append(xs, ys)` must return the elements of `xs` followed by the elements of
`ys`; recurse on `xs`. `len(xs)` must return how many elements `xs` has;
recurse on `xs`.

`append_nil_left` says appending the empty list on the left changes nothing;
since `append` matches on its first argument, it computes away by itself.
`len_append` says the length of an append is the sum of the lengths. That one
is inductive in `xs`, and in the step case the induction hypothesis rewrites
the tail.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`,
as `def L.append_nil_left(xs)` and `def L.len_append(xs, ys)`.
