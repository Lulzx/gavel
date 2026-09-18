Implement `reverse` on lists of `Nat`, then prove the law about it.

`reverse(xs)` must return the elements of `xs` in the opposite order. Recurse on
`xs`: `Nil{}` reverses to itself, and `h <> t` returns
`append(reverse(t), h <> Nil{})` -- the head goes on the right, behind the
reversed tail.

`append` is given in `prelude.bend` and is not yours to change, so the law
speaks about `reverse` alone.

The law `rev_append` says that reversing a list that ends in one new element
puts that element on the left. It is inductive in `xs`: `append` matches on its
first argument, so with a variable `xs` on the left the goal does not reduce.
Both sides unfold to the same cons cell, and the step case needs the induction
hypothesis read the other way round, because the goal has
`reverse(append(t, x <> Nil{}))` where the hypothesis has `x <> reverse(t)`.

This law pins `reverse` by itself -- there is no companion law. The general form
`reverse(append(xs, ys)) == append(reverse(ys), reverse(xs))` does not: a
`reverse` whose body is `Nil{}` reduces both sides of it to `Nil{}`. Here the
right-hand side is `x <> reverse(xs)`, so a body that drops the list differs
from it for a variable `xs`.

Write the implementation in `solution.bend` and the proof in `PROOF.bend`, as
`def L.rev_append(xs, x)`.
