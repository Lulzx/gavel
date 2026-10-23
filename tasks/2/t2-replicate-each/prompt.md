Implement `replicate_each`, then prove the five laws in `LAWS.bend`.

`replicate_each(xs, n)` is `xs` with every element repeated `n` times in place,
keeping the order of the elements. The empty list, or a count of `0n`, gives
`Nil{}`. The lists are `List<&2, Nat>`.

    replicate_each([1n, 2n], 3n) == [1n, 1n, 1n, 2n, 2n, 2n]
    replicate_each([1n, 2n], 0n) == Nil{}
    replicate_each([5n], 2n) == [5n, 5n]
    replicate_each(Nil{}, 3n) == Nil{}

The laws use `P.rep(x, k)`, the list of `k` copies of `x`, and
`P.append(xs, ys)`, the concatenation of two lists.

- `replicate_each_nil`: the empty list gives `Nil{}`, whatever `n` is.
- `replicate_each_zero`: a count of `0n` gives `Nil{}`, whatever the list.
- `replicate_each_cons`: `replicate_each(x <> t, n)` is the `P.rep(x, n)`
  followed (via `P.append`) by `replicate_each(t, n)`.
- `replicate_each_one`: a count of `1n` gives the list itself.
- `replicate_each_two`: `replicate_each([1n, 2n], 2n)` is `[1n, 1n, 2n, 2n]`.
