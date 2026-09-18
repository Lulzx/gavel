Implement `append` on lists of `Nat`, then prove its laws.

`append(xs, ys)` must return the elements of `xs` followed by the elements of
`ys`. Recurse on the first argument: `Nil{}` returns `ys` and `h <> t` returns
`h <> append(t, ys)`.

The law `append_nil_left` says that appending to an empty list on the left
returns the other list unchanged. It closes by direct computation: `append`
matches on its first argument, so `append(Nil{}, xs)` reduces to `xs`.

The law `append_nil` says that appending nothing on the right returns the list
unchanged. This one is inductive in `xs`, since `append` does not reduce on a
variable first argument. It is the companion that pins `append`: `append_assoc`
is satisfied by the projection `append(xs, ys) = ys`, and this law is not.

The law `append_assoc` says that `append(append(xs, ys), zs)` equals
`append(xs, append(ys, zs))`. It is inductive in `xs`: both sides of the step
reduce to a cons cell in front of the two tails, and the induction hypothesis
matches those tails exactly.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.append_nil_left(xs)`, `def L.append_nil(xs)` and
`def L.append_assoc(xs, ys, zs)`.
