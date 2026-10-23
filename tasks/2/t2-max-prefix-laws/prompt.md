Implement `max_prefix`, then prove the four laws in `LAWS.bend`.

`max_prefix(n, xs)` is the largest of the first `n` elements of `xs`. It is
`0n` when `n` is `0n` or `xs` is empty, and when `xs` has fewer than `n`
elements it is the largest of all of them.

    max_prefix(2n, [4n, 9n, 7n]) == 9n
    max_prefix(1n, [4n, 9n, 7n]) == 4n
    max_prefix(5n, [4n, 9n]) == 9n
    max_prefix(0n, [4n]) == 0n

The laws use the prelude's `P.len(xs)`, the number of elements of `xs`;
`P.max(a, b)`, the larger of two numbers; and `P.max_list(xs)`, the largest
element of `xs`, `0n` for the empty list.

- `max_prefix_zero`: a count of `0n` gives `0n`, whatever the list.
- `max_prefix_len`: taking as many elements as the list has gives `P.max_list(xs)`.
- `max_prefix_nil`: an empty list gives `0n`, whatever the count.
- `max_prefix_step`: with a count of `1n + k` and a list `h <> t`, the answer is
  the larger, by `P.max`, of `h` and the largest of the first `k` elements of `t`.
