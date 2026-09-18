Implement `snoc` on lists of `Nat`, then prove the law about it.

`snoc(xs, x)` must return the elements of `xs` followed by `x` -- the new
element goes on the right, unlike a cons cell. Recurse on `xs`: `Nil{}` returns
`x` on its own, and `h <> t` returns `h <> snoc(t, x)`.

`reverse` is given in `prelude.bend` and is not yours to change, so the law
speaks about `snoc` alone.

The law `rev_snoc` says that reversing a list with one element added on the
right puts that element on the left. It is inductive in `xs`: `snoc` matches on
its first argument, so with a variable `xs` on the left the goal does not
reduce. The step case needs the induction hypothesis read the other way round,
because the goal has `reverse(snoc(t, x))` where the hypothesis has
`x <> reverse(t)`.

This law pins `snoc` by itself -- there is no companion law. A `snoc` that
ignores its arguments is either `Nil{}` or `xs`, and the two sides of the law
differ from `x <> reverse(xs)` in both cases.

Write the implementation in `solution.bend` and the proof in `PROOF.bend`, as
`def L.rev_snoc(xs, x)`.
