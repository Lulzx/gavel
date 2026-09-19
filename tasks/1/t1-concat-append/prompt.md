Implement `concat` on lists of lists of `Nat`, then prove the two laws about
it.

`concat(xss)` must return the inner lists of `xss`, one after another, as a
single list. Recurse on the outer list: `Nil{}` flattens to `Nil{}`, and
`a <> rest` returns `append(a, concat(rest))`.

`append` is given in `prelude.bend` and is not yours to change. Note that
`List` in Base is monomorphic, so `prelude.bend` also carries a second
`append_ll` for the outer list; the law is stated in terms of both.

`concat_nil` is the base: the empty list of lists concatenates to the empty
list. Its proof is `{==}` -- `concat(Nil{})` unfolds to `Nil{}`, and there is
nothing left to say.

`concat_append` is the step: concatenating a list of lists that ends in one more
list is the same as appending that list to the concatenation. It is inductive in
`xss`: `append_ll` matches on its first argument, so with a variable `xss` on
the left the goal does not reduce.

The two are a complete recursion and neither is enough alone. A relative law --
one whose two sides are both applications of the target -- cannot pin a function
by itself, because a body that wraps its result in anything constant cancels on
both sides. `concat_append` alone is satisfied by
`concat(xss) = [0n] ++ reference(xss)`, which is not the reference at any list
of lists; it was measured at tier 4 with a full reward before `concat_nil` was
added. `concat_nil` is the absolute anchor that makes the wrapper visible.

The step case needs two facts that are not definitional, because `append`
matches on its first argument: that `append(xs, Nil{}) == xs`, and that
`append` reassociates. Both are yours to prove, under the reserved `Policy.*`
namespace, as `def Policy.append_nil(xs)` and
`def Policy.append_assoc(xs, ys, zs)`. Mark the parameters that appear only in
a lemma's statement as erased (`-ys`) so that calling it does not consume the
caller's lists.

Write the implementation in `solution.bend` and the proof in `PROOF.bend`, as
`def L.concat_nil()` and `def L.concat_append(xss, ys)`.
