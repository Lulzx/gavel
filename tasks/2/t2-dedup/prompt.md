Implement `dedup`, then prove the four laws in `LAWS.bend`.

`dedup(xs)` deletes adjacent duplicates: whenever two neighbouring elements are
the same number, only one of them is kept. Equal elements that are not
neighbours are untouched. The empty list and a one-element list are unchanged.

    dedup([1n, 1n, 2n, 2n, 1n]) == [1n, 2n, 1n]
    dedup([4n, 4n, 4n]) == [4n]
    dedup([1n, 2n, 1n]) == [1n, 2n, 1n]
    dedup(Nil{}) == Nil{}

The prelude's `P.same(a, b)` is `True{}` when `a` and `b` are the same number and
`False{}` otherwise. `P.same_put(h, r, k)` is `r` when `k` is `True{}` and
`h <> r` when `k` is `False{}`.

- `dedup_nil`: the empty list stays empty.
- `dedup_single`: a one-element list is unchanged.
- `dedup_cons`: for a list `a <> (b <> t)` of two or more elements, the answer is
  `P.same_put(a, dedup(b <> t), P.same(a, b))`: the first element is dropped when
  it is the same as the second, and otherwise kept in front of `dedup(b <> t)`.
- `dedup_same`: two equal neighbours collapse, so
  `dedup(a <> (a <> t)) == dedup(a <> t)`.
