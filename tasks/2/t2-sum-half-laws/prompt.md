Implement `sum_half`, then prove the two laws in `LAWS.bend`.

`sum_half(xs)` is the sum, over every element of `xs`, of each element halved, rounded down. The empty list
gives `0n`.

    sum_half([2n, 0n, 3n]) == 2n
    sum_half([4n]) == 2n
    sum_half(Nil{}) == 0n

The laws use the prelude's `P.half(n)`, which is `n` halved, rounded down, and `P.append(xs, ys)`,
the list `xs` followed by the list `ys`.

- `sum_half_nil`: the empty list gives `0n`.
- `sum_half_snoc`: putting one element `x` on the end of `xs` gives the result for
  `xs` plus `P.half(x)`.
