Implement `snoc`, then prove the two laws in `LAWS.bend`.

`snoc(xs, x)` is `xs` with `x` added at the end.

    snoc([1n, 2n], 3n) == [1n, 2n, 3n]
    snoc(Nil{}, 5n) == [5n]
    snoc([4n], 4n) == [4n, 4n]

The laws use `P.append(xs, ys)`, the concatenation of two lists.

- `snoc_nil`: `snoc(Nil{}, x)` is `x <> Nil{}`.
- `snoc_append`: `snoc(P.append(xs, ys), x)` is `P.append(xs, snoc(ys, x))`.
