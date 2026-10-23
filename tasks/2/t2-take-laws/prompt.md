Implement `take`, then prove the three laws in `LAWS.bend`.

`take(n, xs)` is the first `n` elements of `xs`, in order. When `xs` has fewer
than `n` elements it is all of `xs`. `take(0n, xs)` is the empty list.

    take(2n, [4n, 1n, 7n]) == [4n, 1n]
    take(0n, [4n, 1n, 7n]) == Nil{}
    take(5n, [4n, 1n]) == [4n, 1n]

The laws use the prelude's `P.len(xs)`, the number of elements of `xs`, and
`P.append(xs, ys)`, the list `xs` followed by the list `ys`.

- `take_succ`: taking `1n + k` elements of `h <> xs` gives `h` followed by the
  first `k` elements of `xs`.
- `take_append_len`: taking as many elements as `xs` has from `xs` followed by
  `ys` gives `xs`.
- `take_nil`: taking from the empty list gives the empty list, whatever the
  count.
