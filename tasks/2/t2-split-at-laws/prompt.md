Implement `split_at`, which cuts a list at an index, then prove the laws that
say what the two pieces are.

`split_at(n, xs)` must return the first `n` elements of `xs` together with
everything after them, so `split_at(2n, 1n <> (2n <> (3n <> Nil{})))` is
`1n <> (2n <> Nil{})` and `3n <> Nil{}`. The two pieces are a data type of the
prelude's own, `P.Duo`, with a constructor `P.MkDuo{}` and two projections,
`P.left_half` and `P.right_half`. Recurse on the count: a count of `0n` puts
everything in the second half, and a successor count takes the head of a
non-empty list into the first half and recurses on the tail. The head is
substituted into the tail's first half by reading the tail's pair twice -- once
for each half -- so the tail is marked reusable.

The law `split_at_zero` fixes the answer where the count is `0n`: nothing is
taken, so the first half is empty and the second half is the whole list.

The law `split_at_nil` fixes the answer where the list is empty: however large
the count, there is nothing to take and both halves are empty. Neither of these
is reached by the step laws below, which name a successor count and a cons cell
respectively.

The laws `split_at_cons_left` and `split_at_cons_right` are the step, one
projection each. The first says the head of the list joins the front of the
first half; the second says the second half is exactly the second half of the
tail's pair. Together they say which piece each element lands in, and a body
that put the head in the wrong half, or that dropped it, fails one of them.

The law `split_at_decomp` says that putting the two halves back together with
`P.append` gives back the list that was split. It is inductive in the count, and
it is the law that says no element is lost and none is counted twice: a body
that took one element too many, or too few, agrees with the two halves at every
single point the step laws name and disagrees here.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.split_at_zero(xs)`, `def L.split_at_nil(n)`, `def L.split_at_cons_left(n,
x, xs)`, `def L.split_at_cons_right(n, x, xs)` and `def L.split_at_decomp(n,
xs)`.
