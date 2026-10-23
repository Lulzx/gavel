Implement `sum_nonzero`, then prove the two laws in `LAWS.bend`.

`sum_nonzero(xs)` is the number of elements of `xs` that are not `0n`. The empty
list gives `0n`.

    sum_nonzero([2n, 0n, 3n]) == 2n
    sum_nonzero([4n]) == 1n
    sum_nonzero(Nil{}) == 0n

The laws use the prelude's `P.is_nonzero(n)`, which is `0n` when `n` is `0n` and
`1n` otherwise, and `P.append(xs, ys)`, the list `xs` followed by the list `ys`.

- `sum_nonzero_nil`: the empty list gives `0n`.
- `sum_nonzero_snoc`: putting one element `x` on the end of `xs` gives the
  result for `xs` plus `P.is_nonzero(x)`.
