Implement `count_odd_prefix`, then prove the four laws in `LAWS.bend`.

`count_odd_prefix(n, xs)` is the number of odd numbers among the first `n`
elements of `xs`. When `xs` has fewer than `n` elements it counts the odd
numbers in all of them.

    count_odd_prefix(2n, [3n, 4n, 5n]) == 1n
    count_odd_prefix(3n, [3n, 4n, 5n]) == 2n
    count_odd_prefix(0n, [3n, 4n, 5n]) == 0n
    count_odd_prefix(5n, [3n, 4n]) == 1n

The prelude's `P.len(xs)` is the number of elements of `xs`. `P.is_odd(n)` is
`1n` when `n` is odd and `0n` when it is even. `P.count_odd(xs)` is the number
of odd elements of `xs`.

- `count_odd_prefix_zero`: a count of `0n` gives `0n`, whatever the list is.
- `count_odd_prefix_len`: counting over as many elements as the list has is
  counting over the whole list, `count_odd_prefix(P.len(xs), xs) == P.count_odd(xs)`.
- `count_odd_prefix_nil`: the empty list gives `0n`, whatever the count is.
- `count_odd_prefix_step`: with a count of `1n + k` and a list `h <> t`, the
  answer is `P.is_odd(h)` added to `count_odd_prefix(k, t)`.
