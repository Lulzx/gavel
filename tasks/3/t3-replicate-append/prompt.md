Implement `replicate`, then prove the four laws in `LAWS.bend`.

`replicate(n, x)` is the list of `n` copies of `x`.

    replicate(3n, 7n) == [7n, 7n, 7n]
    replicate(0n, 7n) == Nil{}

The prelude's `P.len(xs)` is the number of elements of `xs`,
`P.append(xs, ys)` is `xs` followed by `ys`, and `P.rev(xs)` is `xs` reversed
(it is built from `P.snoc(xs, y)`, which puts `y` on the end of `xs`).

- `replicate_len`: `n` copies of `x` have `n` elements.
- `replicate_append`: `n + m` copies of `x` are `n` copies followed by `m`
  copies.
- `replicate_single`: one copy of `x` is the one-element list `[x]`.
- `rev_replicate`: reversing `n` copies of `x` gives the same list back.
