Implement `take` and `drop`, then prove the three laws in `LAWS.bend`.

`take(n, xs)` is the first `n` elements of `xs`, and `drop(n, xs)` is everything
after them. When `xs` has fewer than `n` elements, `take` returns all of `xs` and
`drop` returns `Nil{}`.

    take(2n, [4n, 5n, 6n]) == [4n, 5n]
    drop(2n, [4n, 5n, 6n]) == [6n]
    take(5n, [4n, 5n]) == [4n, 5n]
    drop(5n, [4n, 5n]) == Nil{}

`P.append(xs, ys)` is `xs` followed by `ys`, `P.len(xs)` is the number of
elements of `xs`, and `P.min(a, b)` is the smaller of `a` and `b`.

- `take_drop`: appending `drop(n, xs)` to `take(n, xs)` gives back `xs`.
- `drop_drop`: dropping `m` elements after dropping `n` is dropping `n + m`.
- `take_len`: `take(n, xs)` has `P.min(n, P.len(xs))` elements.
