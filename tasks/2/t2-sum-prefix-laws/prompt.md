Implement `sum_prefix`, then prove the four laws in `LAWS.bend`.

`sum_prefix(n, xs)` is the sum of the first `n` elements of `xs`. When `xs` has
fewer than `n` elements it is the sum of all of them:

    sum_prefix(2n, [4n, 1n, 7n]) == 5n
    sum_prefix(0n, [4n, 1n, 7n]) == 0n
    sum_prefix(5n, [4n, 1n])     == 5n

The laws use the prelude's `P.len(xs)`, the number of elements of `xs`, and
`P.sum(xs)`, the sum of all of them.

- `sum_prefix_zero`: the sum of no elements is `0n`.
- `sum_prefix_len`: summing as many elements as the list has is summing the
  whole list.
- `sum_prefix_nil`: an empty list sums to `0n`, whatever the count.
- `sum_prefix_step`: with a count of `1n + k` and a list `h <> t`, the answer is
  `h` plus the sum of the first `k` elements of `t`.
