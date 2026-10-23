Implement `drop`, then prove the three laws in `LAWS.bend`.

`drop(n, xs)` removes the first `n` elements of `xs` and returns the rest. With
`n` equal to `0n` the list comes back unchanged. If `xs` has fewer than `n`
elements the answer is the empty list.

    drop(2n, [5n, 6n, 7n]) == [7n]
    drop(0n, [5n])         == [5n]
    drop(5n, [5n])         == Nil{}

The laws use two prelude names. `P.len(xs)` is the number of elements of `xs`.
`P.append(xs, ys)` is the list `xs` followed by the list `ys`.

- `drop_succ`: `drop(1n + k, h <> t)` is `drop(k, t)`.
- `drop_append_len`: dropping `P.len(xs)` elements from `P.append(xs, ys)` leaves
  `ys`.
- `drop_nil`: `drop(k, Nil{})` is `Nil{}`, whatever `k` is.
