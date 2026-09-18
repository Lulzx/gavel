Implement `len(xs)` on lists of `Nat`, then prove the laws about it.

`len(xs)` must return the number of elements in `xs`. Recurse on `xs`: `Nil{}`
is the base case and returns `0n`, and `h <> t` returns `1n+len(t)`.

The law `len_cons` says that consing one element onto a list makes it one
element longer. It closes by direct computation -- `len` reduces on a non-empty
list, so both sides become `1n+len(xs)` -- so its proof body is just `{==}`.

The law `len_single` is the weak companion that pins the base case. `len_cons`
constrains only the cons step, so a `len` that gets `Nil{}` wrong still satisfies
it; this one does not. It also closes by direct computation.

The law `len_nil_right` says that appending nothing on the right does not change
a list's length. `append` is supplied by the prelude, and it matches on its
first argument, so with a variable `xs` on the left the goal does not reduce on
its own. This one is inductive in `xs`: in the `h <> t` case the induction
hypothesis at `t` rewrites the right side into the left.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.len_cons(x, xs)`, `def L.len_single(x)` and `def L.len_nil_right(xs)`.
