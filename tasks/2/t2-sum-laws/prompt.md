Implement `append` and `sum` on lists of `Nat`, then prove the four laws.

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

The last two laws are what make `append` an obligation rather than a name the
set passes around. `sum_append` is about `sum`, and a sum cannot see a
permutation: a body that recurses on its own list and pushes the head onto the
*other* one returns `reverse(xs) <> ys`, keeps every element and therefore every
sum, so the two laws above are satisfied by a body that does not concatenate.
`append_cons` observes order -- it is `append`'s cons step read back -- and
`append_nil_left` says the empty list is the left identity, without which
`append(Nil{}, ys)` stays free in content because only its sum is fixed. Both
close by reduction, so `{==}` is their whole proof.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`,
as `def L.sum_append(xs, ys)`, `def L.sum_single(h)`,
`def L.append_cons(h, t, ys)` and `def L.append_nil_left(ys)`.
