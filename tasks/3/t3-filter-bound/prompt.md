Implement `filter` and `len`, then prove the three laws in `LAWS.bend`.

`filter(xs, n)` is the elements of `xs` that are at most `n`, in their original
order. `len(xs)` is the number of elements of `xs`.

    filter([3n, 1n, 4n, 2n], 2n) == [1n, 2n]
    filter([5n], 2n) == Nil{}
    len([3n, 1n, 4n]) == 3n

The prelude's `P.le(a, b)` is `True{}` when `a` is at most `b`.
`P.below_count(xs, n)` is the number of elements of `xs` that are at most `n`.
`P.filter_put(h, r, k)` is `h <> r` when `k` is `True{}` and `r` otherwise, and
`P.below_put(c, k)` is `1n + c` when `k` is `True{}` and `c` otherwise.

- `filter_len`: the length of `filter(xs, n)` is exactly
  `P.below_count(xs, n)`.
- `filter_keep`: filtering `h <> t` with threshold `h` keeps `h` in front of
  the filtered `t`.
- `filter_drop`: when `P.le(y, h)` is `False{}`, filtering `y <> t` with
  threshold `h` is filtering `t` with threshold `h`.
