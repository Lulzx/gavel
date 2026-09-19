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

Those two laws are both about `sum`, and a sum cannot see a permutation, so they
do not by themselves say what `append` answers -- only what its total is. A body
that recursed on its own list and pushed the head onto the other one would
return `reverse(xs) <> ys`, keep every element, and keep every sum. The last two
laws say it directly, on `append` rather than through `sum`: `append_cons` puts
the head of the first list at the front of the answer, and `append_nil_left`
makes the empty case answer its second argument as a value rather than only up
to a sum. Together they are `append`'s definition written out, and both close by
direct computation -- the head goes out in front of the recursive call, and the
empty case is its second argument.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.sum_cons(x, xs)`, `def L.sum_append(xs, ys)`, `def L.append_cons(h, t, ys)`
and `def L.append_nil_left(ys)`.
