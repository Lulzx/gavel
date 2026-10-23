Implement `nappend`, then prove the three laws in `LAWS.bend`.

`nappend(xs, n)` is `n` copies of the list `xs` concatenated, so zero copies is
the empty list.

    nappend([1n, 2n], 3n) == [1n, 2n, 1n, 2n, 1n, 2n]
    nappend([1n, 2n], 0n) == Nil{}
    nappend(Nil{}, 4n) == Nil{}

The list type is the prelude's `List<&2, Nat>`. `P.append(xs, ys)` is `xs`
followed by `ys`, and `P.len(xs)` is the number of elements of `xs`. `*` is
Base's multiplication.

- `nappend_zero`: zero copies of `xs` is the empty list.
- `nappend_succ`: `1n + p` copies of `xs` is `xs` followed by `p` copies of
  `xs`.
- `nappend_len`: `n` copies of `xs` have `n` times as many elements as `xs`.
