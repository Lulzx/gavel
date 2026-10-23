Implement `sum_mod3`, then prove the two laws in `LAWS.bend`.

`sum_mod3(xs)` is the sum, over every element of `xs`, of each element's remainder on division by three. The empty list
gives `0n`.

    sum_mod3([2n, 0n, 3n]) == 2n
    sum_mod3([4n]) == 1n
    sum_mod3(Nil{}) == 0n

The laws use the prelude's `P.mod3(n)`, which is the remainder of `n` on division by three, and `P.append(xs, ys)`,
the list `xs` followed by the list `ys`.

- `sum_mod3_nil`: the empty list gives `0n`.
- `sum_mod3_snoc`: putting one element `x` on the end of `xs` gives the result for
  `xs` plus `P.mod3(x)`.
