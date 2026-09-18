Implement `len` and `append` on lists of `Nat`, then prove the laws about `len`.

`len(xs)` must return the number of elements in `xs`. Recurse on `xs`: `Nil{}`
is the base case and returns `0n`, and `h <> t` returns `1n+len(t)`.

`append(xs, ys)` must return the elements of `xs` followed by the elements of
`ys`. Recurse on the first argument: `Nil{}` returns `ys` and `h <> t` returns
`h <> append(t, ys)`.

The law `len_cons` says that consing one element onto a list makes it one
element longer. It closes by direct computation: `len` reduces on a non-empty
list, so both sides become `1n+len(xs)`.

The law `len_single` is the weak companion that pins the base case. `len_cons`
constrains only the cons step, so a `len` that gets `Nil{}` wrong still satisfies
it; this one does not.

The law `len_nil_right` says that appending nothing on the right does not change
a list's length. This one is inductive in `xs`: `append` matches on its first
argument, so with a variable `xs` on the left the goal does not reduce on its
own. In the `h <> t` case, the induction hypothesis at `t` rewrites the right
side into the left.

The law `append_nil_left` pins `append` itself: `len_nil_right` is satisfied by
the projection `append(xs, ys) = xs`, and this one is not.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.len_cons(x, xs)`, `def L.len_single(x)`, `def L.len_nil_right(xs)` and
`def L.append_nil_left(ys)`.
