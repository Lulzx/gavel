Implement `reverse` on lists of `Nat`, then prove the two laws about it.

`reverse(xs)` must return the elements of `xs` in the opposite order. Recurse on
`xs`: `Nil{}` reverses to itself, and `h <> t` returns
`append(reverse(t), h <> Nil{})` -- the head goes on the right, behind the
reversed tail.

`append` is given in `prelude.bend` and is not yours to change, so the law
speaks about `reverse` alone.

`rev_nil` is the base: the empty list reverses to itself. Its proof is `{==}` --
`reverse(Nil{})` unfolds to `Nil{}`, and the two sides are then the same term.

`rev_append` is the step: reversing a list that ends in one new element puts
that element on the left. It is inductive in `xs`: `append` matches on its first
argument, so with a variable `xs` on the left the goal does not reduce. Both
sides unfold to the same cons cell, and the step case needs the induction
hypothesis read the other way round, because the goal has
`reverse(append(t, x <> Nil{}))` where the hypothesis has `x <> reverse(t)`.

The two are a complete recursion and neither is enough alone. A relative law --
one whose two sides are both applications of the target -- cannot pin a function
by itself, because a body that wraps its result in anything constant cancels on
both sides. `rev_append` alone is satisfied by
`reverse(xs) = reference(xs) ++ [0n]`, which is not the reference at any list;
it was measured at tier 4 with a full reward before `rev_nil` was added.
`rev_nil` is the absolute anchor that makes the wrapper visible.

Write the implementation in `solution.bend` and the proof in `PROOF.bend`, as
`def L.rev_nil()` and `def L.rev_append(xs, x)`.
