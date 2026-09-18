Implement `sum` and `append` on lists of `Nat`, then prove the laws about `sum`.

`sum(xs)` must return the total of the elements. Recurse on `xs`: `Nil{}`
returns `0n`, and `h <> t` returns `h + sum(t)`.

`append(xs, ys)` must return the elements of `xs` followed by the elements of
`ys`. Recurse on the first argument: `Nil{}` returns `ys` and `h <> t` returns
`h <> append(t, ys)`.

The law `sum_cons` says that consing one element onto a list adds that element
to the total. It closes by direct computation: `sum` reduces on a non-empty
list, so both sides become `x + sum(xs)`.

The law `sum_append` says that the sum of `append(xs, ys)` is the sum of `xs`
plus the sum of `ys`. It is inductive in `xs`. Watch the arithmetic: adding the
head of a cons cell makes both sides of the step grow by the same amount, but
the parentheses do not line up on their own, so the step needs a lemma about how
`+` reassociates. Define that lemma in `PROOF.bend`; helper lemmas must be named
`Policy.<something>`, and they may take erased parameters.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.sum_cons(x, xs)` and `def L.sum_append(xs, ys)`.
