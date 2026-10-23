Implement `take`, then prove the one law in `LAWS.bend`.

`take(xs, n)` is the first `n` elements of `xs`, in order. If `xs` has fewer
than `n` elements it is all of `xs`.

    take([1n, 2n, 3n], 2n) == [1n, 2n]
    take([1n, 2n], 5n)     == [1n, 2n]
    take([1n, 2n], 0n)     == Nil{}
    take(Nil{}, 3n)        == Nil{}

The law uses `P.append(xs, ys)`, the elements of `xs` followed by those of
`ys`, and `P.drop(xs, n)`, `xs` without its first `n` elements (`Nil{}` if it
has fewer than `n`).

- `take_drop`: `P.append(take(xs, n), P.drop(xs, n))` is `xs`, so the first `n`
  elements followed by the rest give back the whole list.
