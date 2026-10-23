Implement `windows_go` and `windows`, then prove the five laws in `LAWS.bend`.

`windows(k, xs)` is every run of `k` consecutive elements of `xs`, in the order
they start. A list of three elements has two windows of length `2n` and none of
length `4n`, and a length of `0n` has no windows at all. The empty list has no
windows for any `k`.

`windows_go(ys, k, xs)` is the walk behind it: it gives one window per element
of `ys`, ignoring the values in `ys`. The first window is the first `k` elements
of `xs`, the next is the first `k` elements of `xs` with its first element
removed, and so on. For a positive `k`, `windows` runs it with a `ys` that has one element per
window.

    windows(2n, [1n, 2n, 3n]) == [[1n, 2n], [2n, 3n]]
    windows(3n, [1n, 2n, 3n]) == [[1n, 2n, 3n]]
    windows(4n, [1n, 2n, 3n]) == Nil{}
    windows_go([0n, 0n], 2n, [5n, 6n, 7n]) == [[5n, 6n], [6n, 7n]]

The laws use four prelude names. `P.take(xs, n)` is the first `n` elements of
`xs`, or all of `xs` if it has fewer. `P.tail(xs)` is `xs` without its first
element, and `Nil{}` for the empty list. `P.lookahead(xs, k)` is `Nil{}` when `k`
is `0n`, and otherwise `xs` with its first `k - 1n` elements removed, which has
one element per window of length `k`.

- `windows_zero`: a length of `0n` gives no windows, for any list.
- `windows_succ`: `windows(1n + k, xs)` is `windows_go` run over
  `P.lookahead(xs, 1n + k)` with the length `1n + k` and the list `xs`.
- `windows_nil`: the empty list gives no windows, for any `k`.
- `windows_go_nil`: with an empty `ys` the walk gives no windows, whatever `k`
  and `xs` are.
- `windows_go_step`: with `ys` equal to `h <> t`, the walk gives the window
  `P.take(xs, k)` followed by the walk over `t` with the same `k` and with
  `P.tail(xs)` in place of `xs`.
