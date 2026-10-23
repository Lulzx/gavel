Implement `sum_triple`, then prove the two laws in `LAWS.bend`.

`sum_triple(xs)` is the sum, over every element of `xs`, of three times each element. The empty list
gives `0n`.

    sum_triple([2n, 0n, 3n]) == 15n
    sum_triple([4n]) == 12n
    sum_triple(Nil{}) == 0n

The laws use the prelude's `P.triple(n)`, which is `n + n + n`, and `P.append(xs, ys)`,
the list `xs` followed by the list `ys`.

- `sum_triple_nil`: the empty list gives `0n`.
- `sum_triple_snoc`: putting one element `x` on the end of `xs` gives the result for
  `xs` plus `P.triple(x)`.
