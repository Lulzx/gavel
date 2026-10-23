Implement `sum_dec2`, then prove the two laws in `LAWS.bend`.

`sum_dec2(xs)` is the sum, over every element of `xs`, of each element minus two, stopping at `0n`. The empty list
gives `0n`.

    sum_dec2([2n, 0n, 3n]) == 1n
    sum_dec2([4n]) == 2n
    sum_dec2(Nil{}) == 0n

The laws use the prelude's `P.dec2(n)`, which is `n` minus two, stopping at `0n`: `0n` when `n` is `0n` or `1n`, and `P.append(xs, ys)`,
the list `xs` followed by the list `ys`.

- `sum_dec2_nil`: the empty list gives `0n`.
- `sum_dec2_snoc`: putting one element `x` on the end of `xs` gives the result for
  `xs` plus `P.dec2(x)`.
