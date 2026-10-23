Implement `count_inv`, then prove the four laws in `LAWS.bend`.

`count_inv(xs)` counts the inversions of `xs`: the pairs of positions `i < j`
where the earlier element is strictly greater than the later one. Equal elements
are not an inversion. A list with fewer than two elements has none.

    count_inv([3n, 1n, 2n]) == 2n
    count_inv([1n, 2n, 3n]) == 0n
    count_inv([2n, 2n]) == 0n
    count_inv(Nil{}) == 0n

The prelude's `P.count_gt(x, ys)` is the number of elements of `ys` that are
strictly below `x`. `P.replicate(n, x)` is the list of `n` copies of `x`.

- `count_inv_nil`: the empty list has `0n` inversions.
- `count_inv_single`: a one-element list has `0n` inversions.
- `count_inv_cons`: for a list `h <> t`, the inversions are `P.count_gt(h, t)`
  (those with `h` as the earlier element) plus `count_inv(t)`.
- `count_inv_replicate`: a list of `n` equal elements has `0n` inversions.
