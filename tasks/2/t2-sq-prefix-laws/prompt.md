Implement `sq_prefix`, then prove the four laws in `LAWS.bend`.

`sq_prefix(n, xs)` is the sum of the squares of the first `n` elements of `xs`.
When `xs` has fewer than `n` elements it is the sum of the squares of all of
them.

    sq_prefix(2n, [3n, 2n, 5n]) == 13n
    sq_prefix(0n, [3n, 2n, 5n]) == 0n
    sq_prefix(5n, [3n, 2n]) == 13n

The laws use the prelude's `P.len(xs)`, the number of elements of `xs`,
`P.sq(n)`, which is `n * n`, and `P.sq_sum(xs)`, the sum of the squares of all
the elements of `xs`.

- `sq_prefix_zero`: the sum of the squares of no elements is `0n`.
- `sq_prefix_len`: taking as many elements as the list has gives the sum of the
  squares of the whole list.
- `sq_prefix_nil`: an empty list gives `0n`, whatever the count.
- `sq_prefix_step`: with a count of `1n + k` and a list `h <> t`, the answer is
  `P.sq(h)` plus the sum of the squares of the first `k` elements of `t`.
