Implement `count_up` and `count_down`, then prove the seven laws in `LAWS.bend`.

`count_up(n)` is the list `[0n, 1n, ..., n - 1n]`, counting up, and
`count_down(n)` is the list `[n - 1n, ..., 1n, 0n]`, counting down. Both are
empty for `n = 0n` and have `n` elements.

    count_up(3n) == [0n, 1n, 2n]
    count_down(3n) == [2n, 1n, 0n]
    count_up(0n) == Nil{}
    count_down(1n) == [0n]

The prelude's `P.snoc(xs, y)` is `xs` with `y` added at the end. `P.rev(xs)` is
`xs` reversed. `P.len(xs)` is the number of elements of `xs`.

- `count_up_zero`: `count_up(0n)` is the empty list.
- `count_up_succ`: `count_up(1n + k)` is `count_up(k)` with `k` added at the end
  (using `P.snoc`).
- `count_down_zero`: `count_down(0n)` is the empty list.
- `count_down_succ`: `count_down(1n + k)` is `k` followed by `count_down(k)`.
- `count_up_rev_count_down`: reversing `count_up(n)` gives `count_down(n)`.
- `len_count_up`: `count_up(n)` has `n` elements, `P.len(count_up(n)) == n`.
- `len_count_down`: `count_down(n)` has `n` elements.
