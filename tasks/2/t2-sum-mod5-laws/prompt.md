Implement `sum_mod5`, then prove the two laws in `LAWS.bend`.

`sum_mod5(xs)` is the sum, over every element of `xs`, of each element's remainder on division by five. The empty list
gives `0n`.

    sum_mod5([2n, 0n, 3n]) == 5n
    sum_mod5([4n]) == 4n
    sum_mod5(Nil{}) == 0n

The laws use the prelude's `P.mod5(n)`, which is the remainder of `n` on division by five, and `P.append(xs, ys)`,
the list `xs` followed by the list `ys`.

- `sum_mod5_nil`: the empty list gives `0n`.
- `sum_mod5_snoc`: putting one element `x` on the end of `xs` gives the result for
  `xs` plus `P.mod5(x)`.
