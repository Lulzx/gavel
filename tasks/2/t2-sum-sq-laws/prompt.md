Implement `sq_sum`, then prove the two laws in `LAWS.bend`.

`sq_sum(xs)` is the sum, over every element of `xs`, of the square of each element. The empty list
gives `0n`.

    sq_sum([2n, 0n, 3n]) == 13n
    sq_sum([4n]) == 16n
    sq_sum(Nil{}) == 0n

The laws use the prelude's `P.sq(n)`, which is `n * n`, and `P.append(xs, ys)`,
the list `xs` followed by the list `ys`.

- `sq_sum_nil`: the empty list gives `0n`.
- `sq_sum_snoc`: putting one element `x` on the end of `xs` gives the result for
  `xs` plus `P.sq(x)`.
