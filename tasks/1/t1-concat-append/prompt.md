Implement `concat` on lists of lists of `Nat`, then prove the law about it.

`concat(xss)` must return the inner lists of `xss`, one after another, as a
single list. Recurse on the outer list: `Nil{}` flattens to `Nil{}`, and
`a <> rest` returns `append(a, concat(rest))`.

`append` is given in `prelude.bend` and is not yours to change. Note that
`List` in Base is monomorphic, so `prelude.bend` also carries a second
`append_ll` for the outer list; the law is stated in terms of both.

The law `concat_append` says that concatenating a list of lists that ends in one
more list is the same as appending that list to the concatenation. It is
inductive in `xss`: `append_ll` matches on its first argument, so with a
variable `xss` on the left the goal does not reduce.

This law pins `concat` by itself -- there is no companion law. The only body
that ignores `xss` is `Nil{}`, and the two sides are then `Nil{}` and `ys`,
which differ for a variable `ys`.

The step case needs two facts that are not definitional, because `append`
matches on its first argument: that `append(xs, Nil{}) == xs`, and that
`append` reassociates. Both are yours to prove, under the reserved `Policy.*`
namespace, as `def Policy.append_nil(xs)` and
`def Policy.append_assoc(xs, ys, zs)`. Mark the parameters that appear only in
a lemma's statement as erased (`-ys`) so that calling it does not consume the
caller's lists.

Write the implementation in `solution.bend` and the proof in `PROOF.bend`, as
`def L.concat_append(xss, ys)`.
