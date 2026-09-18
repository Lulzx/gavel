Implement `append` on lists of `Nat`, then prove the laws about it.

`append(xs, ys)` must return the elements of `xs` followed by the elements of
`ys`. Recurse on the first argument: `Nil{}` is the base case and `h <> t`
splits a non-empty list into head and tail.

The law `append_nil` says that appending the empty list on the right changes
nothing. It is inductive in `xs`, since `append` does not reduce on a variable.

The law `append_nil_left` says that appending the empty list on the left returns
the other list unchanged. It closes by direct computation, and it is what pins
`append`: `append_nil` alone is satisfied by the projection
`append(xs, ys) = xs`, which ignores `ys` entirely.

The law `append_cons` says what `append` does to a cons cell. `append` reduces on
the cons, so its proof closes by direct computation too. It pins the cons case:
the projection onto the second argument satisfies `append_nil_left` and this law
does not.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.append_nil(xs)`, `def L.append_nil_left(ys)` and
`def L.append_cons(x, xs, ys)`.
