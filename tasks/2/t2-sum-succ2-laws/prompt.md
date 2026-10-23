Implement `sum_succ2`, then prove the two laws in `LAWS.bend`.

`sum_succ2(xs)` is the sum, over every element of `xs`, of each element plus two. The empty list
gives `0n`.

    sum_succ2([2n, 0n, 3n]) == 11n
    sum_succ2([4n]) == 6n
    sum_succ2(Nil{}) == 0n

The laws use the prelude's `P.succ2(n)`, which is `n + 2n`, and `P.append(xs, ys)`,
the list `xs` followed by the list `ys`.

- `sum_succ2_nil`: the empty list gives `0n`.
- `sum_succ2_snoc`: putting one element `x` on the end of `xs` gives the result for
  `xs` plus `P.succ2(x)`.
