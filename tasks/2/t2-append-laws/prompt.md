Implement `append` and `len` on lists of `Nat`, then prove both laws.

`append(xs, ys)` must return the elements of `xs` followed by the elements of
`ys`; recurse on `xs`. `len(xs)` must return how many elements `xs` has;
recurse on `xs`.

`len_cons` says consing one more element onto a list adds one to its length;
since `len` steps on the cons cell, it computes away by itself. `len_append`
says the length of an append is the sum of the lengths. That one is inductive in
`xs`, and its step case needs the associativity of `+` to move the head past the
two lengths -- `+` is stuck on a variable head, so that reassociation is a lemma
of its own, under the reserved `Policy.` namespace.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`,
as `def L.len_cons(x, xs)` and `def L.len_append(xs, ys)`.
