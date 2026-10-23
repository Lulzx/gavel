Implement `zeros_prefix`, then prove the four laws in `LAWS.bend`.

`zeros_prefix(n, xs)` is the number of elements equal to `0n` among the first
`n` elements of `xs`. When `xs` has fewer than `n` elements it counts the zeros
in all of them.

    zeros_prefix(3n, [0n, 5n, 0n, 0n]) == 2n
    zeros_prefix(0n, [0n, 0n]) == 0n
    zeros_prefix(5n, [0n, 4n]) == 1n

The laws use three prelude names. `P.is_zero(n)` is `1n` when `n` is `0n` and
`0n` otherwise. `P.len(xs)` is the number of elements of `xs`.
`P.count_zeros(xs)` is the number of elements of `xs` equal to `0n`.

- `zeros_prefix_zero`: looking at the first `0n` elements finds no zeros.
- `zeros_prefix_len`: looking at as many elements as the list has counts all of
  its zeros, `P.count_zeros(xs)`.
- `zeros_prefix_nil`: an empty list has no zeros, whatever the count.
- `zeros_prefix_step`: with a count of `1n + k` and a list `h <> t`, the answer
  is `P.is_zero(h)` plus the number of zeros among the first `k` elements of
  `t`.
