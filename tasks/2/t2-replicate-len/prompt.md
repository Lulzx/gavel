Implement `replicate`, then prove the two laws in `LAWS.bend`.

`replicate(n, x)` is the list of `n` copies of `x`.

    replicate(3n, 7n) == [7n, 7n, 7n]
    replicate(1n, 4n) == [4n]
    replicate(0n, 4n) == Nil{}

The laws use `P.len(xs)`, the number of elements of `xs`.

- `replicate_succ`: `replicate(1n + n, x)` is `x <> replicate(n, x)`.
- `replicate_len`: `replicate(n, x)` has `n` elements.
