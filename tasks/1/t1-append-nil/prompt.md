Implement `append` on lists of `Nat`, then prove the law about it.

`append(xs, ys)` must return the elements of `xs` followed by the elements of
`ys`. Recurse on the first argument: `Nil{}` is the base case and `h <> t`
splits a non-empty list into head and tail.

The law `append_nil` says that appending the empty list changes nothing. It is
inductive in `xs`.

Write the implementation in `solution.bend` and the proof in `PROOF.bend`, as
`def L.append_nil(xs)`.
