Implement `sum_sq_inc`, then prove the two laws in `LAWS.bend`.

`sum_sq_inc(xs)` is the sum, over every element of `xs`, of the square of each element plus one. The empty list
gives `0n`.

    sum_sq_inc([2n, 0n, 3n]) == 16n
    sum_sq_inc([4n]) == 17n
    sum_sq_inc(Nil{}) == 0n

The laws use the prelude's `P.sq_inc(n)`, which is `n * n + 1n`, and `P.append(xs, ys)`,
the list `xs` followed by the list `ys`.

- `sum_sq_inc_nil`: the empty list gives `0n`.
- `sum_sq_inc_snoc`: putting one element `x` on the end of `xs` gives the result for
  `xs` plus `P.sq_inc(x)`.
