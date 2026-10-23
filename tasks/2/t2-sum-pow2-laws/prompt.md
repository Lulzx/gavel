Implement `sum_pow2`, then prove the two laws in `LAWS.bend`.

`sum_pow2(xs)` is the sum, over every element of `xs`, of two to the power of each element. The empty list
gives `0n`.

    sum_pow2([2n, 0n, 3n]) == 13n
    sum_pow2([4n]) == 16n
    sum_pow2(Nil{}) == 0n

The laws use the prelude's `P.pow2(n)`, which is two to the power `n`, and `P.append(xs, ys)`,
the list `xs` followed by the list `ys`.

- `sum_pow2_nil`: the empty list gives `0n`.
- `sum_pow2_snoc`: putting one element `x` on the end of `xs` gives the result for
  `xs` plus `P.pow2(x)`.
