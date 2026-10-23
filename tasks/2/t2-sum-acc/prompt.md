Implement `sum_acc`, then prove the two laws in `LAWS.bend`.

`sum_acc(xs, acc)` is `acc` plus every element of `xs`. The empty list leaves
`acc` unchanged.

    sum_acc([1n, 2n, 3n], 10n) == 16n
    sum_acc([4n], 0n) == 4n
    sum_acc(Nil{}, 7n) == 7n

The laws use the prelude's `P.append(xs, ys)`, the list `xs` followed by the
list `ys`.

- `sum_acc_single`: summing the one-element list `[h]` onto `0n` gives `h`.
- `sum_acc_append`: summing the concatenation of `xs` and `ys` onto `acc` is
  summing `ys` onto the result of summing `xs` onto `acc`.
